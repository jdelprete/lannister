class AddShopifyIdToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :shopify_id, :bigint
  end
end
