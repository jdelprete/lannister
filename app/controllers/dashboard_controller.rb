class DashboardController < ApplicationController
  def index
    @num_orders_to_order = current_user.aliexpress_orders.where(ali_order_number: nil).group(:order_id).count.length
    @num_orders_processing = current_user.aliexpress_orders.where.not(ali_order_number: nil).where(tracking_code: nil).group(:order_id).count.length

    orders = Order.after(7.days.ago.beginning_of_day, field: :ordered_at)

    # variables for line graph
    orders_by_day = orders.to_a.group_by_day(&:ordered_at)
    @sales_data = orders.group_by_day(:ordered_at).sum(:total_price)
    @orders_data = orders.group_by_day(:ordered_at).count
    @cost_data = orders_by_day.reduce({}) do |result, (date, orders)|
      result[date] = orders.sum(&:total_cost)
      result
    end

    # variables for table
    @total_cost = orders.sum(&:total_cost).round(2)
    @total_sales = orders.sum(:total_price).round(2) # doesn't need ampersand since total_price is a column
    @order_count = orders.size
    @total_earnings = (@total_sales - @total_cost).round(2)

    @currency = Order.last.currency
  end
end
