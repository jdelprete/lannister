class RemoveProductFromImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :product_id, :integer
  end
end
