class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.date :start_date
      t.date :end_date
      t.date :pick_up_date
      t.date :return_date
      t.int :release_form_id
      t.kit :references
      t.user :references

      t.timestamps
    end
  end
end
