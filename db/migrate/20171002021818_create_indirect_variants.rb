class CreateIndirectVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :indirect_variants do |t|
      t.belongs_to :product_variant
      t.belongs_to :product
      t.bigint :shopify_id
      t.string :sku
      t.timestamps
    end
  end
end
