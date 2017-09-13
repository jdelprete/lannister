class CreateVariantOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :variant_options do |t|
      t.string :title
      t.string :sku
      t.string :category
      t.timestamps
    end
  end
end
