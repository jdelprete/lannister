class Order < ApplicationRecord
  has_many :aliexpress_orders, dependent: :destroy
  serialize :shipping_address, JSON

  def self.create_from_shopify_order(shopify_order)
    order = Order.new
    order.shopify_id = shopify_order.id
    order.shopify_order_number = shopify_order.number
    order.ordered_at = DateTime.parse(shopify_order.created_at)
    order.currency = shopify_order.currency
    order.shipping_address = shopify_order.shipping_address.attributes

    if order.shipping_address.country_code == 'GB'
      outward = order.shipping_address.zip.match(/^([A-Z]{1,2}\d{1,2}[A-Z]?)\s*(\d[A-Z]{2})$/).captures.first
      order.shipping_address.province = UkCounties.find_by(postcode_district: outward)
    end

    order.save

    line_items = shopify_order.line_items.map { |li| LineItem.create_from_shopify_line_item(li) }

    line_items.group_by { |li| li.product.aliexpress_shop }.each do |aliexpress_shop, line_item_groups|
      ali_order = order.aliexpress_orders.create(aliexpress_shop_id: aliexpress_shop.id)
      ali_order.line_items << line_item_groups
    end

    order
  end
end
