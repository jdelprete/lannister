class VariantOption < ApplicationRecord
  has_and_belongs_to_many :product_variants
  belongs_to :product

  def as_shopify_option
    shopify_option = ShopifyAPI::Option.new
    shopify_option.name = self.category
    shopify_option
  end
end
