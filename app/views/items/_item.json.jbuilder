json.extract! item, :id, :readable_id, :condition, :kit_id, :item_category_id, :is_active, :created_at, :updated_at
json.url item_url(item, format: :json)
