class DropProductVariantsProductsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :product_variants_products
  end
end
