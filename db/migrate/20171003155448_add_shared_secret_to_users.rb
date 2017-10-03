class AddSharedSecretToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :shared_secret, :string
  end
end
