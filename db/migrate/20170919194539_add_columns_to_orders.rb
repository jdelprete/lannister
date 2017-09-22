class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :fulfilled, :boolean
    add_column :orders, :ali_order_number, :bigint
    add_column :orders, :ordered_at, :datetime
  end
end
