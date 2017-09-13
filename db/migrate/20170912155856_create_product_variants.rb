class CreateProductVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :product_variants do |t|
      t.float :price
      t.belongs_to :product
      t.string :url
      t.string :sku
      t.timestamps
    end
  end
end
