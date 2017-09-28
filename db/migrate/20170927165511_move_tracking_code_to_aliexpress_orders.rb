class MoveTrackingCodeToAliexpressOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :tracking_code, :string
    add_column :aliexpress_orders, :tracking_code, :string
  end
end
