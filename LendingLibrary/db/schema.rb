# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180218062336) do

  create_table "component_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components", force: :cascade do |t|
    t.integer "max_quantity"
    t.integer "damaged"
    t.integer "missing"
    t.boolean "consumable"
    t.integer "item_id"
    t.integer "component_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_category_id"], name: "index_components_on_component_category_id"
    t.index ["item_id"], name: "index_components_on_item_id"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "item_photo"
    t.integer "inventory_level"
    t.integer "amount_available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "readable_id"
    t.string "condition"
    t.integer "kit_id"
    t.integer "item_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_category_id"], name: "index_items_on_item_category_id"
    t.index ["kit_id"], name: "index_items_on_kit_id"
  end

  create_table "kits", force: :cascade do |t|
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.date "pick_up_date"
    t.date "return_date"
    t.boolean "returned", default: false
    t.integer "release_form_id"
    t.integer "kit_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kit_id"], name: "index_reservations_on_kit_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "street_1"
    t.string "street_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_num"
    t.integer "school_id"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_users_on_school_id"
  end

end
