class CreateProductVariantsVariantOptionsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :product_variants_variant_options, id: false do |t|
      t.integer :product_variant_id, index: true
      t.integer :variant_option_id, index: true
    end
  end
end
