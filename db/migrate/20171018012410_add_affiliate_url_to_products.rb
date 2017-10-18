class AddAffiliateUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :affiliate_url, :string
  end
end
