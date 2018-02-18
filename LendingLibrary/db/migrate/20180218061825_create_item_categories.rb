class CreateItemCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :item_categories do |t|
      t.string :name
      t.string :description
      t.int :inventory_level
      t.int :amount_available

      t.timestamps
    end
  end
end
