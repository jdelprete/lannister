module DashboardHelper
  def format_chart_data(data)
    '[' + data.map do |k, v|
      "{ x: #{k.to_time.to_i * 1000}, y: #{v} }"
    end.join(', ') + ']'
  end
end
