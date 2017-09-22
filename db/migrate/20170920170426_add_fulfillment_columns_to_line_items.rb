class AddFulfillmentColumnsToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :has_shipped, :boolean, default: false
    add_column :line_items, :tracking_code, :string
  end
end
