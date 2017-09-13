class MakeImagePolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_reference :images, :imageable, polymorphic: true, index: true
  end
end
