json.extract! reservation, :id, :start_date, :end_date, :pick_up_date, :return_date, :release_form_id, :references, :references, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
