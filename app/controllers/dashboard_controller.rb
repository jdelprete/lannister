class DashboardController < ApplicationController
  def index
    @num_orders_to_order = current_user.aliexpress_orders.where(ali_order_number: nil).group(:order_id).count.length
    @num_orders_processing = current_user.aliexpress_orders.where.not(ali_order_number: nil).where(tracking_code: nil).group(:order_id).count.length

    chart_data = get_chart_data(7.days.ago, Time.now)

    # variables for line graph
    @total_price_by_day = chart_data[:total_price_by_day]
    @order_count_by_day = chart_data[:order_count_by_day]
    @total_cost_by_day = chart_data[:total_cost_by_day]

    # variables for table
    @total_cost = chart_data[:total_cost]
    @total_sales = chart_data[:total_sales]
    @order_count = chart_data[:order_count]
    @total_earnings = (@total_sales - @total_cost).round(2)

    @currency = chart_data[:currency]
  end

  def json
    return render json: { error: 'missing parameters date_from or date_to parameters' } unless params[:date_from] && params[:date_to]

    date_from = Time.parse(params[:date_from])
    date_to = Time.parse(params[:date_to])

    chart_data = get_chart_data(date_from, date_to)
    chart_data[:total_price_by_day] = helpers.format_chart_data(chart_data[:total_price_by_day])
    chart_data[:total_cost_by_day] = helpers.format_chart_data(chart_data[:total_cost_by_day])
    chart_data[:order_count_by_day] = helpers.format_chart_data(chart_data[:order_count_by_day])

    render json: chart_data
  end

  private

  def get_chart_data(date_from, date_to)

    date_from = date_from.beginning_of_day
    date_to = date_to.end_of_day

    orders = Order.between_times(date_from, date_to, field: :ordered_at)

    # variables for line graph
    orders_by_day = orders.to_a.group_by_day(&:ordered_at)

    chart_data = {
      total_price_by_day: orders.group_by_day(:ordered_at).sum(:total_price),
      total_cost_by_day: orders_by_day.reduce({}) { |result, (date, orders)| result[date] = orders.sum(&:total_cost) and result },
      order_count_by_day: orders.group_by_day(:ordered_at).count,
      total_cost: orders.sum(&:total_cost).round(2),
      total_sales: orders.sum(:total_price).round(2), # doesn't need ampersand since total_price is a column
      order_count: orders.size,
      currency: Order.last.currency
    }

    (date_from.to_date..date_to.to_date).each do |date|
      chart_data[:total_price_by_day][date] = 0 unless chart_data[:total_price_by_day][date]
      chart_data[:total_cost_by_day][date] = 0 unless chart_data[:total_cost_by_day][date]
      chart_data[:order_count_by_day][date] = 0 unless chart_data[:order_count_by_day][date]
    end

    chart_data
  end
end
