class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone_num
      t.school :references
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
