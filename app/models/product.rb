class Product < ApplicationRecord
  before_destroy :remove_primary_image
  has_many :images, dependent: :destroy
  belongs_to :primary_image, class_name: 'Image', optional: true
  belongs_to :aliexpress_shop
  belongs_to :user
  has_many :product_variants, dependent: :destroy
  has_many :variant_options, dependent: :destroy
  has_many :indirect_variants, dependent: :destroy

  def self.create_from_url(product_url, user)
    product_url = product_url.split('?').first

    return nil if user.products.find_by(url: product_url)

    product = user.products.new
    product.url = product_url

    browser = Watir::Browser.new(:phantomjs)
    browser.goto(product.url)
    browser.element(class: 'description-content').hover
    browser.element(css: '.description-content img').wait_until_present
    product_page = Nokogiri::HTML(browser.html)
    variant_objs = browser.execute_script('return skuProducts')
    gallery_imgs = browser.execute_script('return window.runParams.imageBigViewURL')
    browser.quit

    store_anchor = product_page.at_css('.shop-name > a')
    store_id = store_anchor['href'].split('/').reject(&:empty?).last
    store_name = store_anchor.text
    product.aliexpress_shop = AliexpressShop.create_with(name: store_name).find_or_create_by(ali_store_id: store_id)

    product.title = product_page.at_css('.product-name').text

    product.description = product_page.css('.product-property-list li').reduce('<p>') do |desc, li|
      key = li.at_css('.propery-title').text
      val = li.at_css('.propery-des').text
      desc + "<span><strong>#{key}</strong> #{val}</span><br/>"
    end + '</p>'

    product.save

    # get images from gallery
    gallery_imgs.each_with_index do |img, idx|
      if idx == 0
        img = product.images.create(url: img)
        product.update(primary_image: img)
      else
        product.images.create(url: img)
      end
    end

    # get images from description
    product_page.css('.description-content img').each do |img|
      product.images.create(url: img['src'])
    end

    # get images from variants
    product_page.css('.sku-attr-list img').each do |img|
      product.images.create(url: img['bigpic'])
    end

    # get variants
    variants = product.get_variants(product_page, variant_objs)

    product
  end

  def get_variants(product_page, variant_objs)
    options = product_page.css('#j-product-info-sku > .p-property-item').inject({}) do |opts, elem|
      category = elem.at_css('.p-item-title').text[0..-2]
      ali_prop_id = elem.at_css('.sku-attr-list')['data-sku-prop-id'].to_i

      opts[ali_prop_id] = { :category => category }

      option_imgs = elem.css('img')

      if option_imgs.size > 0
        opts[ali_prop_id][:images] = option_imgs.inject({}) do |img_hash, img|
          img_hash[img.parent['data-sku-id'].to_i] = img['bigpic']
          img_hash
        end
      end

      opts
    end

    variant_objs.each do |variant_obj|
      cost = variant_obj['skuVal']['actSkuCalPrice'].to_f
      inventory = variant_obj['skuVal']['inventory']
      variant = self.product_variants.create(cost: cost, inventory: inventory)

      if variant_obj['skuAttr']
        variant_obj['skuAttr'].split(';').each do |skuAttr|
          attrs = skuAttr.split(/[#:]/)

          ali_prop_id = attrs[0].to_i
          ali_sku = attrs[1].to_i
          title = attrs[2] || product_page.css("[data-sku-id='#{ali_sku}']").text.strip
          category = options[ali_prop_id][:category]

          variant.variant_options << self.variant_options.find_or_create_by(title: title, category: category, ali_sku_prop: ali_prop_id, ali_sku: ali_sku)

          variant.update(image: self.images.find_by(url: options[ali_prop_id][:images][ali_sku])) if options[ali_prop_id][:images]
        end
      end

      variant.update(image: self.primary_image) unless variant.image
    end
  end

  def sorted_variant_options
    self.variant_options.select('distinct on (category) category').sort_by { |o| o.category }
  end

  def as_shopify_product
    shopify_product = ShopifyAPI::Product.new

    shopify_product.title = self.title
    shopify_product.body_html = self.description
    shopify_product.options = self.sorted_variant_options.map(&:as_shopify_option) if has_many_variants?
    shopify_product.variants = self.all_variants.map(&:as_shopify_variant)
    shopify_product.images = self.images.map(&:as_shopify_image) unless has_many_variants? # images are added after to get the variant ids

    shopify_product
  end

  def import
    shopify_product = self.as_shopify_product
    shopify_product.save

    # images are added after save to get the variant ids
    shopify_product.images = self.images.map { |img| img.as_shopify_image(shopify_product.variants) } if has_many_variants?


    self.indirect_variants.each do |indirect_variant|
      next if indirect_variant.product_variant.image.nil?

      shopify_image = indirect_variant.product_variant.image.as_shopify_image

      shopify_product.variants.each do |shopify_variant|
        shopify_image.variant_ids << shopify_variant.id if shopify_variant.sku == indirect_variant.sku
      end

      shopify_product.images << shopify_image
    end

    shopify_product.save
    
    self.update(shopify_id: shopify_product.id)

    shopify_product.variants.each do |shopify_variant| 
      if shopify_variant.sku.to_s.include?('-')
        self.indirect_variants.find_by(sku: shopify_variant.sku).update(shopify_id: shopify_variant.id)
      else
        self.product_variants.find(shopify_variant.sku).update(shopify_id: shopify_variant.id)
      end
    end
  end

  def has_many_variants?
    self.product_variants.size + self.indirect_variants.size > 1
  end

  def imported?
    self.shopify_id.present?
  end

  def all_variants
    self.product_variants + self.indirect_variants
  end

  private 

  def remove_primary_image
    self.update(primary_image: nil) # or else there's a foreign key constraint
  end
end
