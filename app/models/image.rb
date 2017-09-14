class Image < ApplicationRecord
  has_many :product_variants
  has_one :product

  def as_shopify_image
    shopify_img = Shopify::Image.new
    shopify_img.src = self.url
    shopify_img
  end
end
