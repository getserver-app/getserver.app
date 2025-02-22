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

ActiveRecord::Schema[8.0].define(version: 2025_02_20_021340) do
  create_table "emails", force: :cascade do |t|
    t.string "email", limit: 320, null: false
    t.string "responsibility", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_emails_on_email"
  end

  create_table "server_deletions", force: :cascade do |t|
    t.integer "server_id"
    t.datetime "delete_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_server_deletions_on_server_id"
  end

  create_table "servers", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", null: false
    t.string "internal_id", null: false
    t.string "provider_identifier", null: false
    t.string "provider_plan_identifier", null: false
    t.string "provider_os_identifier", null: false
    t.string "provider_region_identifier", null: false
    t.boolean "active", default: true
    t.string "stripe_subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internal_id"], name: "index_servers_on_internal_id"
    t.index ["user_id"], name: "index_servers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "stripe_id", limit: 50, null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verifications", force: :cascade do |t|
    t.string "path", null: false
    t.integer "email_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_verifications_on_email_id"
    t.index ["user_id"], name: "index_verifications_on_user_id"
  end
end
