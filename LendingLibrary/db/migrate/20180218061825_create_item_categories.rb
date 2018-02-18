class CreateItemCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :item_categories do |t|
      t.string :name
      t.string :description
      t.integer :inventory_level
      t.integer :amount_available

      t.timestamps
    end
  end
end
