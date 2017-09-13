class ChangeProductVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :product_variants, :inventory, :integer
    rename_column :product_variants, :price, :cost
    remove_column :product_variants, :sku
  end
end
