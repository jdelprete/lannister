class AddProductToVariantOptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :variant_options, :product, foreign_key: true
  end
end
