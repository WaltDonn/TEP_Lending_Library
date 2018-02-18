class CreateTeachers < ActiveRecord::Migration[5.1]
  def change
    create_table :teachers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone_num
      t.school :references
      t.string :password_digest
      t.boolean :is_active

      t.timestamps
    end
  end
end
