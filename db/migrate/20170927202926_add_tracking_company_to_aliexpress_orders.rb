class AddTrackingCompanyToAliexpressOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :aliexpress_orders, :tracking_company, :string
  end
end
