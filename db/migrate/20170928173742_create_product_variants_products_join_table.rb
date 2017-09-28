class CreateProductVariantsProductsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :product_variants_products, id: false do |t|
      t.belongs_to :product, index: true
      t.belongs_to :product_variant, index: true
    end
  end
end
