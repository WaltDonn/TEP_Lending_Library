class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :readable_id
      t.string :condition
      t.kit :references
      t.item_category :references

      t.timestamps
    end
  end
end
