class AliexpressOrder < ApplicationRecord
  belongs_to :order
  belongs_to :aliexpress_shop
  has_many :line_items, dependent: :destroy

  def fulfillment_info
    # returns all the information necessary to place the order on aliexpress
    fulfillment_info = {
      aliexpress_order_id: self.id,
      shipping_address: order.shipping_address
    }

    fulfillment_info[:line_items] = line_items.reduce([]) do |line_item_arr, line_item|
      variant = line_item.product_variant
      product = variant.product

      variant_options = variant.variant_options.reduce([]) do |opt_arr, opt|
        opt_arr << { ali_sku_prop: opt.ali_sku_prop, ali_sku: opt.ali_sku }
      end

      line_item_arr << { product_url: product.affiliate_url || product.url, quantity: line_item.quantity, variant_options: variant_options }
    end

    fulfillment_info
  end

  def fulfill_items(new_tracking_company, new_tracking_code)
    self.update(
      tracking_code: new_tracking_code,
      tracking_company: new_tracking_company
    )

    if tracking_code.present?
      shopify_fulfillment = ShopifyAPI::Fulfillment.new
      shopify_fulfillment.order_id = order.shopify_id
      shopify_fulfillment.tracking_company = TrackingHelper::ali_to_shopify_tracking_company(new_tracking_company)
      shopify_fulfillment.tracking_numbers = [tracking_code]
      shopify_fulfillment.prefix_options[:order_id] = order.shopify_id
      shopify_fulfillment.line_items = self.line_items.map do |li|
        { id: li.shopify_id }
      end

      tracking_url = TrackingHelper::get_tracking_url(new_tracking_company, new_tracking_code)
      shopify_fulfillment.tracking_urls = [tracking_url] if tracking_url

      shopify_fulfillment.save
    end
  end

  def has_shipped?
    tracking_code.present?
  end
end
