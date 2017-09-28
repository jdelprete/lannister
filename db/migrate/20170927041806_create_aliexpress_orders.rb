class CreateAliexpressOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :aliexpress_orders do |t|
      t.belongs_to :order
      t.belongs_to :aliexpress_shop
      t.bigint :ali_order_number
      t.timestamps
    end
  end
end
