class RemoveAliOrderNumberFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :ali_order_number, :bigint
  end
end
