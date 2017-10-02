class AddUserSettingsColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :shopify_store_name, :string
    add_column :users, :api_key, :string
    add_column :users, :api_password, :string
  end
end
