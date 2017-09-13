class RemoveIsPrimaryFromImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :is_primary
  end
end
