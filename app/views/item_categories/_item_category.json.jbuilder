json.extract! item_category, :id, :name, :description, :item_photo, :inventory_level, :amount_available, :created_at, :updated_at
json.url item_category_url(item_category, format: :json)
