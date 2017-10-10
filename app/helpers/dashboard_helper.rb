module DashboardHelper
  def format_chart_data(data)
    data = Hash[ data.sort_by { |key, val| key } ]

    data.map do |k, v|
      { x: k.strftime('%F'), y: v } 
    end
  end
end
