class LineItem < ApplicationRecord
  belongs_to :aliexpress_order
  belongs_to :product_variant
  has_one :product, through: :product_variant
  has_one :order, through: :aliexpress_order

  def self.create_from_shopify_line_item(shopify_line_item, user)
    unless product_variant = user.product_variants.find_by(shopify_id: shopify_line_item.variant_id)
      indirect_variant = user.indirect_variants.find_by(shopify_id: shopify_line_item.variant_id)
      product_variant = indirect_variant.product_variant if indirect_variant.present?
    end

    return nil if product_variant.nil?

    new_line_item = product_variant.line_items.new(
      quantity: shopify_line_item.quantity, 
      price: shopify_line_item.price,
      variant_title: shopify_line_item.variant_title,
      shopify_id: shopify_line_item.id
    )

    cur_product_title = new_line_item.product.title
    new_line_item.product.update(title: shopify_line_item.title) if cur_product_title != shopify_line_item.title

    new_line_item
  end
end
