class OrdersController < ApplicationController
  def index
    last_order = Order.order('shopify_order_number DESC').first

    ShopifyAPI::Order.all.each do |shopify_order|
      break if last_order && last_order.shopify_order_number >= shopify_order.number

      Order.create_from_shopify_order(shopify_order)
    end

    @orders = Order.order('shopify_order_number DESC')
  end
end
