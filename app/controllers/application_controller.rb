class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :config_shopify_gem, :set_layout_variables, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_layout_variables
    @num_unfulfilled_orders = current_user.aliexpress_orders.where(tracking_code: nil).group(:order_id).count.length
    @num_unimported_products = current_user.products.where(shopify_id: nil).size
  end

  def config_shopify_gem
    ShopifyAPI::Base.site = current_user.store_api_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:shopify_store_name, :api_key, :api_password])
  end
end
