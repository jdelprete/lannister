class CreateAliexpressShops < ActiveRecord::Migration[5.1]
  def change
    create_table :aliexpress_shops do |t|
      t.bigint :ali_store_id
      t.string :name
      t.timestamps
    end
  end
end
