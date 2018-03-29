json.extract! user, :id, :email, :first_name, :last_name, :phone_num, :class_size, :school_id, :is_active, :password_digest, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
