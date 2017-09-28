class AddCurrencyToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :currency, :string
  end
end
