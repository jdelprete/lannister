class Product < ApplicationRecord
  has_many :images, as: :imageable
  belongs_to :primary_image, class_name: 'Image', optional: true
  has_many :product_variants
  has_many :variant_options

  def self.create_from_url(product_url)
    product_url = product_url.split('?').first

    if Product.find_by_url(product_url)
      return nil
    end

    product = Product.new
    product.url = product_url

    browser = Watir::Browser.new(:phantomjs)
    browser.goto(product.url)
    browser.element(class: 'description-content').hover
    browser.element(css: '.description-content img').wait_until_present
    product_page = Nokogiri::HTML(browser.html)
    variant_objs = browser.execute_script('return skuProducts')
    gallery_imgs = browser.execute_script('return window.runParams.imageBigViewURL')
    browser.quit

    product.title = product_page.at_css('.product-name').text

    product_desc = product_page.css('.product-property-list li').reduce('') do |desc, li|
      key = li.at_css('.propery-title').text
      val = li.at_css('.propery-des').text
      desc + "<strong>#{key}</strong>: #{val}\n"
    end

    product.save

    # get images from gallery
    gallery_imgs.each_with_index do |img, idx|
      if idx == 0
        img = product.images.create(url: img)
        product.primary_image = img
        product.save
      else
        product.images.create(url: img)
      end
    end

    # get images from description
    product_page.css('.description-content img').each do |img|
      product.images.create(url: img['src'])
    end

    # get variants
    variants = product.get_variants(product_page, variant_objs)

    product
  end

  def get_variants(product_page, variant_objs)
    options = product_page.css('#j-product-info-sku > .p-property-item').inject({}) do |opts, elem|
      category = elem.at_css('.p-item-title').text[0..-2]
      prop_id = elem.at_css('.sku-attr-list')['data-sku-prop-id'].to_i

      opts[prop_id] = { :category => category }

      option_imgs = elem.css('img')

      if option_imgs.size > 0
        opts[prop_id][:images] = option_imgs.inject({}) do |img_hash, img|
          img_hash[img.parent['data-sku-id'].to_i] = img['bigpic']
          img_hash
        end
      end

      opts
    end

    variant_objs.each do |variant_obj|
      cost = variant_obj['skuVal']['actSkuCalPrice'].to_f
      inventory = variant_obj['skuVal']['inventory']
      variant = ProductVariant.new(product: self, cost: cost, inventory: inventory)
      variant.save

      variant_obj['skuAttr'].split(';').each do |skuAttr|
        attrs = skuAttr.split(/[#:]/)

        prop_id = attrs[0].to_i
        sku = attrs[1].to_i
        title = attrs[2]
        category = options[prop_id][:category]

        variant.variant_options << VariantOption.find_or_create_by(title: title, category: category, sku_prop: prop_id, sku: sku, product: self)

        variant.create_image(url: options[prop_id][:images][sku]) if options[prop_id][:images]
      end
    end
  end

  def sorted_variant_option_categories
    self.variant_options.select('distinct on (category) category').map { |o| o.category }.sort
  end
end
