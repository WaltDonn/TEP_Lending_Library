json.extract! item_category, :id, :name, :description, :inventory_level, :amount_available, :created_at, :updated_at
json.url item_category_url(item_category, format: :json)
