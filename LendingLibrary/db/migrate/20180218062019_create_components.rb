class CreateComponents < ActiveRecord::Migration[5.1]
  def change
    create_table :components do |t|
      t.int :max_quantity
      t.int :damaged
      t.int :missing
      t.boolean :consumable
      t.item :references
      t.component_category :references

      t.timestamps
    end
  end
end
