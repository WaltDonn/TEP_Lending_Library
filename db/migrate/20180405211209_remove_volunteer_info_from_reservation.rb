class RemoveVolunteerInfoFromReservation < ActiveRecord::Migration[5.1]
  def change
    remove_column :reservations, :user_check_in, :string
    remove_column :reservations, :user_check_out, :string
  end
end
