class AddAliexpressOrderToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :aliexpress_order, foreign_key: true
    remove_column :line_items, :order_id, :bigint
  end
end
