class DropUkCounties < ActiveRecord::Migration[5.1]
  def change
    drop_table :uk_counties
  end
end
