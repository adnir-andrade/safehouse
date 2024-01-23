# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_23_062935) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "infection_claims", force: :cascade do |t|
    t.bigint "whistleblower_id", null: false
    t.bigint "infected_survivor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["infected_survivor_id"], name: "index_infection_claims_on_infected_survivor_id"
    t.index ["whistleblower_id", "infected_survivor_id"], name: "idx_on_whistleblower_id_infected_survivor_id_4cefb097c6", unique: true
    t.index ["whistleblower_id"], name: "index_infection_claims_on_whistleblower_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "survivor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survivor_id"], name: "index_inventories_on_survivor_id"
  end

  create_table "inventories_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "inventory_id"
    t.integer "quantity"
    t.index ["inventory_id"], name: "index_inventories_items_on_inventory_id"
    t.index ["item_id"], name: "index_inventories_items_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.decimal "longitude"
    t.decimal "latitude"
    t.bigint "survivor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survivor_id"], name: "index_locations_on_survivor_id"
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.integer "age"
    t.boolean "is_alive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.bigint "location_id"
    t.boolean "is_archived"
    t.integer "infection_claim_count", default: 0
    t.integer "wallet", default: 0
    t.index ["inventory_id"], name: "index_survivors_on_inventory_id"
    t.index ["location_id"], name: "index_survivors_on_location_id"
  end

  add_foreign_key "infection_claims", "survivors", column: "infected_survivor_id"
  add_foreign_key "infection_claims", "survivors", column: "whistleblower_id"
  add_foreign_key "inventories", "survivors"
  add_foreign_key "locations", "survivors"
  add_foreign_key "survivors", "inventories"
  add_foreign_key "survivors", "locations"
end
