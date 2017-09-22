class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.bigint :shopify_id
      t.integer :shopify_order_number
      t.timestamps
    end
  end
end
