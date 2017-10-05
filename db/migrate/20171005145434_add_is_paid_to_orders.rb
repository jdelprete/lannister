class AddIsPaidToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_paid, :boolean
  end
end
