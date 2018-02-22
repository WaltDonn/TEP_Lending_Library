class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :readable_id
      t.string :condition
      t.references :kit
      t.references :item_category

      t.timestamps
    end
  end
end
