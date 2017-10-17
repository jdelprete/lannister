class AddAliexpressApiSettingsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :aliexpress_api_key, :string
    add_column :users, :aliexpress_affiliate_tracking_id, :string
  end
end
