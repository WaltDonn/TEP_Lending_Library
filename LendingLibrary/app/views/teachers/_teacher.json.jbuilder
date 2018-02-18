json.extract! teacher, :id, :email, :first_name, :last_name, :phone_num, :references, :password_digest, :is_active, :created_at, :updated_at
json.url teacher_url(teacher, format: :json)
