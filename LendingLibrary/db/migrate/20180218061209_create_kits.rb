class CreateKits < ActiveRecord::Migration[5.1]
  def change
    create_table :kits do |t|
      t.string :location
      t.boolean :is_active
      t.boolean :blackout
      t.boolean :reserved

      t.timestamps
    end
  end
end
