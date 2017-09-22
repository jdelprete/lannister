class RemoveFulfilledFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :fulfilled, :boolean
  end
end
