module AliexpressOrdersHelper
  def get_formatted_price(line_item)
    Money.new(line_item.price * 100, line_item.order.currency).format
  end
end
