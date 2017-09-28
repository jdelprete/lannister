class AliexpressOrdersController < ApplicationController
  def update
    aliexpress_order = AliexpressOrder.find(params[:id])
    aliexpress_order.update(ali_order_number: params[:ali_order_number]) if params[:ali_order_number]

    aliexpress_order.fulfill_items(params[:tracking_company], params[:tracking_code]) if params[:tracking_code]
  end
end
