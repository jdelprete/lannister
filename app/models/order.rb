class Order < ApplicationRecord
  has_many :aliexpress_orders, dependent: :destroy
  has_many :line_items, through: :aliexpress_orders
  belongs_to :user
  serialize :shipping_address, JSON

  def self.create_from_shopify_order(shopify_order, user)
    if user.orders.find_by(shopify_id: shopify_order.id)
      logger.info { "Order with ID #{shopify_order.id} already created" }
      return nil
    end

    line_items = shopify_order.line_items.reduce([]) do |arr, shopify_li| 
      if shopify_li.is_a?(Hash)
        shopify_li = ShopifyAPI::LineItem.new.from_json(shopify_li.to_json)
      end

      li = LineItem.create_from_shopify_line_item(shopify_li, user)
      arr << li if li
      arr
    end

    return nil if line_items.empty? # there are no line items handled by lannister

    order = user.orders.new(
      shopify_id: shopify_order.id,
      shopify_order_number: shopify_order.number,
      shopify_name: shopify_order.name,
      ordered_at: DateTime.parse(shopify_order.created_at),
      currency: shopify_order.currency,
      total_price: shopify_order.total_price.to_f,
      is_paid: shopify_order.financial_status == 'paid',
      shipping_address: shopify_order.shipping_address.is_a?(Hash) ? shopify_order.shipping_address : shopify_order.shipping_address.attributes
    )
    
    if order.save
      logger.info { "Order #{order.shopify_order_number} created" }
    else
      logger.error { "Order #{order.shopify_order_number} could not be created: #{order.errors.full_messages.to_sentence}" }
      return
    end

    line_items.group_by { |li| li.product.aliexpress_shop }.each do |aliexpress_shop, line_item_groups|
      ali_order = order.aliexpress_orders.create(aliexpress_shop_id: aliexpress_shop.id)
      ali_order.line_items << line_item_groups
    end

    order
  end

  def total_cost
    self.line_items.reduce(0) do |total_cost, line_item|
      total_cost += line_item.product_variant.cost
    end
  end

  def total_profit
    (total_price - total_cost).round(2)
  end
end
