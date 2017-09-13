class ChangeVariantOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :variant_options, :sku_prop, :integer
    add_column :variant_options, :sku, :integer
  end
end
