class OrdersController < ApplicationController
  def index
    last_order = current_user.orders.order('shopify_order_number DESC').first

    ShopifyAPI::Order.all.each do |shopify_order|
      break if last_order && last_order.shopify_order_number >= shopify_order.number

      Order.create_from_shopify_order(shopify_order, current_user)
    end

    if params[:status] == 'to_order'
      @orders = current_user.orders.distinct.joins(:aliexpress_orders).where(:aliexpress_orders => { ali_order_number: nil }).order('shopify_order_number DESC')
    elsif params[:status] == 'processing'
      @orders = current_user.orders.distinct.joins(:aliexpress_orders).where(:aliexpress_orders => { tracking_code: nil }).order('shopify_order_number DESC')
    else
      @orders = current_user.orders.order('shopify_order_number DESC')
    end
  end
end
