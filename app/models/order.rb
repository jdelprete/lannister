class Order < ApplicationRecord
  has_many :aliexpress_orders, dependent: :destroy
  serialize :shipping_address, JSON

  def self.create_from_shopify_order(shopify_order)
    order = Order.new
    order.shopify_id = shopify_order.id
    order.shopify_order_number = shopify_order.number
    order.ordered_at = DateTime.parse(shopify_order.created_at)
    order.shipping_address = shopify_order.shipping_address.attributes

    order.save

    line_items = shopify_order.line_items.map { |li| LineItem.create_from_shopify_line_item(li) }

    line_items.group_by { |li| li.product.aliexpress_shop }.each do |aliexpress_shop, line_item_groups|
      ali_order = order.aliexpress_orders.create(aliexpress_shop_id: aliexpress_shop.id)
      ali_order.line_items << line_item_groups
    end

    order
  end
end
