class RenameVariantOptionColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :variant_options, :sku_prop, :ali_sku_prop
    rename_column :variant_options, :sku, :ali_sku
  end
end
