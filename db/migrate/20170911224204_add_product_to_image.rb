class AddProductToImage < ActiveRecord::Migration[5.1]
  def change
    add_reference :images, :product, foreign_key: true
  end
end
