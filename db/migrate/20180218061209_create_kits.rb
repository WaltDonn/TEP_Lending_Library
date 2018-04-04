class CreateKits < ActiveRecord::Migration[5.1]
  def change
    create_table :kits do |t|
      t.string :location
      t.boolean :is_active, :default => true
      t.boolean :blackout, :default => false
      t.boolean :reserved, :default => false

      t.timestamps
    end
  end
end
