class CreateComponents < ActiveRecord::Migration[5.1]
  def change
    create_table :components do |t|
      t.string :name
      t.integer :max_quantity
      t.integer :damaged
      t.integer :missing
      t.boolean :consumable
      t.references :item

      t.timestamps
    end
  end
end
