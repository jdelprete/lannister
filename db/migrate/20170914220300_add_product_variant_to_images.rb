class AddProductVariantToImages < ActiveRecord::Migration[5.1]
  def change
    add_reference :images, :product_variant, foreign_key: true
    add_reference :images, :product, foreign_key: true
    remove_column :images, :imageable_type
    remove_column :images, :imageable_id
  end
end
