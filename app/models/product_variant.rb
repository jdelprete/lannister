class ProductVariant < ApplicationRecord
  belongs_to :product
  belongs_to :image, optional: true
  has_and_belongs_to_many :variant_options

  def sorted_variant_options
    self.variant_options.sort_by { |o| o.category }
  end

  def title
    self.sorted_variant_options.map { |o| o.title }.join('/')
  end

  def full_title
    "#{self.product.title} - #{self.title}"
  end

  def shopify_sku
    self.id.to_s
  end

  def as_shopify_variant
    shopify_variant = ShopifyAPI::Variant.new

    shopify_variant.inventory_quantity = self.inventory
    shopify_variant.inventory_management = 'shopify'
    shopify_variant.price = self.cost
    shopify_variant.requires_shipping = true
    shopify_variant.title = title
    shopify_variant.sku = shopify_sku

    if self.product.has_many_variants?
      if sorted_variant_options.empty? # this would mean that there are indirect variants but just one direct variant
        shopify_variant.attributes["option1"] = 'Original' # fill with random option so that shopify is happy
      else
        sorted_variant_options.each_with_index do |option, i|
          shopify_variant.attributes["option#{i+1}"] = option.title
        end
      end
    end

    shopify_variant
  end

  def imported?
    self.shopify_id.present?
  end
end
