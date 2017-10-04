class RemoveUrlFromProductVariants < ActiveRecord::Migration[5.1]
  def change
    remove_column :product_variants, :url, :string
  end
end
