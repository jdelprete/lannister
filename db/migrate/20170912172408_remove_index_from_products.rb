class RemoveIndexFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_index "products", name: "index_products_on_primary_image_id"
  end
end
