class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_num
      t.string :phone_ext
      t.integer :class_size
      t.references :school
      t.boolean :is_active
      t.string :role

      t.timestamps
    end
  end
end
