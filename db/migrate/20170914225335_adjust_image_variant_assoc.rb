class AdjustImageVariantAssoc < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :product_variant_id
    add_belongs_to :product_variants, :image
  end
end
