class AddImageReferenceToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :primary_image, references: :images, index: true
    add_foreign_key :products, :images, column: :primary_image_id
  end
end
