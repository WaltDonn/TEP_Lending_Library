json.extract! user, :id, :email, :first_name, :last_name, :phone_num, :references, :password_digest, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
