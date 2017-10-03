class ShopifyWebhooksController < ApplicationController
  before_action :verify_webhook
  skip_before_action :verify_authenticity_token, :authenticate_user!, :config_shopify_gem, :set_layout_variables

  def orders_create
    request.body.rewind
    Order.create_from_shopify_order(ShopifyAPI::Order.new.from_json(request.body.read), @user)
  end

  def products_update
    # only care about the title

    request.body.rewind
    shopify_product = ShopifyAPI::Product.new.from_json(request.body.read)

    product = @user.products.find_by(shopify_id: shopify_product.id)

    if product && product.title != shopify_product.title
      product.update(title: shopify_product.title)
    end
  end

  private

  def verify_webhook
    store_name = request.headers['X-Shopify-Shop-Domain'].split('.').first
    @user = User.find_by(shopify_store_name: store_name)

    request.body.rewind
    request_body = request.body.read

    digest = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, @user.shared_secret, request_body)).strip
    verified = ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'])

    head 403 unless verified
  end
end