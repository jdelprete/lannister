class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.belongs_to :order
      t.belongs_to :product_variant
      t.integer :quantity
    end
  end
end
