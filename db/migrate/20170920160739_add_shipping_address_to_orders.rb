class AddShippingAddressToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :shipping_address, :text
  end
end
