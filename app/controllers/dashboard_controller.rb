class DashboardController < ApplicationController
  def index
    @num_orders_to_order = current_user.aliexpress_orders.where(ali_order_number: nil).group(:order_id).count.length
    @num_orders_processing = current_user.aliexpress_orders.where.not(ali_order_number: nil).where(tracking_code: nil).group(:order_id).count.length
  end
end
