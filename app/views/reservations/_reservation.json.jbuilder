json.extract! reservation, :id, :start_date, :end_date, :pick_up_date, :return_date, :returned, :picked_up, :release_form_id, :kit_id, :teacher_id, :user_check_in_id, :user_check_out_id, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
