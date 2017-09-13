class RemoveSkuFromVariantOptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :variant_options, :sku, :string
  end
end
