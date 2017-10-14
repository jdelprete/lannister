class OrdersController < ApplicationController
  def index
    if params[:status] == 'to_order'
      @orders = current_user.orders.distinct.joins(:aliexpress_orders).where(:aliexpress_orders => { ali_order_number: nil }).order('shopify_order_number DESC')
    elsif params[:status] == 'processing'
      @orders = current_user.orders.distinct.joins(:aliexpress_orders).where(:aliexpress_orders => { tracking_code: nil }).where.not(:aliexpress_orders => { ali_order_number: nil }).order('shopify_order_number DESC')
    else
      @orders = current_user.orders.order('shopify_order_number DESC')
    end

    @orders = @orders.where(shopify_id: params[:shopify_id]) if params[:shopify_id]
    @is_processing_status = params[:status] == 'processing'
  end
end
