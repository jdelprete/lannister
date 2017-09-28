class LineItem < ApplicationRecord
  belongs_to :aliexpress_order
  belongs_to :product_variant
  has_one :product, through: :product_variant
  has_one :order, through: :aliexpress_order

  def self.create_from_shopify_line_item(shopify_line_item)
    new_line_item = LineItem.new(
      quantity: shopify_line_item.quantity, 
      product_variant: ProductVariant.find_by(shopify_id: shopify_line_item.variant_id),
      price: shopify_line_item.price,
      variant_title: shopify_line_item.variant_title,
      shopify_id: shopify_line_item.id
    )

    return nil if new_line_item.product_variant.nil?

    cur_product_title = new_line_item.product.title
    new_line_item.product.update(title: shopify_line_item.title) if cur_product_title != shopify_line_item.title

    new_line_item
  end
end
