class Image < ApplicationRecord
  has_many :product_variants
  has_one :product

  def as_shopify_image(shopify_variants = [])
    shopify_image = ShopifyAPI::Image.new
    shopify_image.src = self.url
    shopify_image.variant_ids = shopify_variants.inject([]) do |variant_ids, shopify_variant|
      variant_ids << shopify_variant.id if self.product_variants.find_by(id: shopify_variant.sku)        
      variant_ids
    end

    shopify_image
  end
end
