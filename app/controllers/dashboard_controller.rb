class DashboardController < ApplicationController
  def index
    @num_orders_to_order = AliexpressOrder.where(ali_order_number: nil).group(:order_id).count.length
    @num_orders_processing = AliexpressOrder.where.not(ali_order_number: nil).where(tracking_code: nil).group(:order_id).count.length
  end
end
