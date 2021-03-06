class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |user|
      ShopifyAPI::Base.site = user.store_api_url

      domain = request.protocol + request.host_with_port

      order_create_webhook = ShopifyAPI::Webhook.new
      order_create_webhook.address = domain + '/shopify/orders/create'
      order_create_webhook.format = 'json'
      order_create_webhook.topic = 'orders/create'
      
      unless order_create_webhook.save
        logger.error { "Could not create orders/create webhook for user #{user.id}: #{order_create_webhook.inspect}" }
      end

      order_paid_webhook = ShopifyAPI::Webhook.new
      order_paid_webhook.address = domain + '/shopify/orders/paid'
      order_paid_webhook.format = 'json'
      order_paid_webhook.topic = 'orders/paid'
      
      unless order_paid_webhook.save
        logger.error { "Could not create orders/paid webhook for user #{user.id}: #{order_paid_webhook.inspect}" }
      end

      product_update_webhook = ShopifyAPI::Webhook.new
      product_update_webhook.address = domain + '/shopify/products/update'
      product_update_webhook.format = 'json'
      product_update_webhook.topic = 'products/update'

      unless product_update_webhook.save
        logger.error { "Could not create products/update webhook for user #{user.id}: #{product_update_webhook.inspect}" }
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
