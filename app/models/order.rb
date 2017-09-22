class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  serialize :shipping_address, JSON

  def self.create_from_shopify_order(shopify_order)
    order = Order.new
    order.shopify_id = shopify_order.id
    order.shopify_order_number = shopify_order.number
    order.ordered_at = DateTime.parse(shopify_order.created_at)
    order.shipping_address = shopify_order.shipping_address.attributes

    order.save

    shopify_order.line_items.each do |shopify_line_item|
      order.line_items << LineItem.create_from_shopify_line_item(shopify_line_item)
    end

    order
  end

  def fulfillment_info
    # returns all the information necessary to place the order on aliexpress
    fulfillment_info = {
      order_id: self.id,
      shipping_address: shipping_address
    }

    fulfillment_info[:line_items] = line_items.reduce([]) do |line_item_arr, line_item|
      variant = line_item.product_variant
      product = variant.product

      variant_options = variant.variant_options.reduce([]) do |opt_arr, opt|
        opt_arr << { ali_sku_prop: opt.ali_sku_prop, ali_sku: opt.ali_sku }
      end

      line_item_arr << { product_url: product.url, quantity: line_item.quantity, variant_options: variant_options }
    end

    fulfillment_info
  end
end
