class AddAliexpressShopToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :aliexpress_shop, foreign_key: true
  end
end
