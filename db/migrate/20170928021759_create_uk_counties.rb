class CreateUkCounties < ActiveRecord::Migration[5.1]
  def change
    create_table :uk_counties do |t|
      t.string :postcode_district, index: true
      t.string :county
    end
  end
end
