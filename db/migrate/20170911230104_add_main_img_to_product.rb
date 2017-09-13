class AddMainImgToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :is_primary, :boolean, :null => false, :default => false
  end
end
