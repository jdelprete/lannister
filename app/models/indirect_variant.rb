class IndirectVariant < ApplicationRecord
  belongs_to :product
  belongs_to :product_variant
  after_create :assign_sku

  def as_shopify_variant
    variant = self.product_variant

    shopify_variant = ShopifyAPI::Variant.new

    shopify_variant.inventory_quantity = variant.inventory
    shopify_variant.inventory_management = 'shopify'
    shopify_variant.price = variant.cost
    shopify_variant.requires_shipping = true
    shopify_variant.title = variant.full_title
    shopify_variant.sku = self.sku

    num_variant_options = self.product.sorted_variant_options.size
    num_variant_options = 1 if num_variant_options == 0

    (1..num_variant_options).each do |i|
      shopify_variant.attributes["option#{i}"] = variant.full_title # fill with random options so that shopify is happy
    end

    shopify_variant
  end

  private

  def assign_sku
    self.update(sku: self.product_variant.id.to_s + '-' + self.id.to_s)
  end
end
