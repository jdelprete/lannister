class AddShopifyIdColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :shopify_id, :int8
    add_column :product_variants, :shopify_id, :int8
  end
end
