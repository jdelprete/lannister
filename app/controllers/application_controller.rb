class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_layout_variables

  private

  def set_layout_variables
    @num_unfulfilled_orders = AliexpressOrder.where(tracking_code: nil).group(:order_id).count.length
  end
end
