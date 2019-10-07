# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_25_121817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nominees", force: :cascade do |t|
    t.string "custom_id", null: false
    t.bigint "poll_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_id"], name: "ak_nominees_custom_id", unique: true
    t.index ["poll_id"], name: "index_nominees_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "custom_id", null: false
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id"
    t.string "state", null: false
    t.datetime "published_at"
    t.datetime "started_at"
    t.datetime "closed_at"
    t.datetime "archived_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_id"], name: "ak_polls_custom_id", unique: true
    t.index ["user_id"], name: "index_polls_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "custom_id", null: false
    t.string "value", null: false
    t.bigint "poll_id", null: false
    t.bigint "nominee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nominee_id"], name: "index_tokens_on_nominee_id"
    t.index ["poll_id", "value"], name: "ak_tokens_poll_id_value", unique: true
    t.index ["poll_id"], name: "index_tokens_on_poll_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "email_verified_at"
    t.string "authentication_token", null: false
    t.datetime "authentication_token_expires_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authentication_token"], name: "ak_users_authentication_token", unique: true
    t.index ["email"], name: "ak_users_email", unique: true
  end

  add_foreign_key "polls", "users"
  add_foreign_key "tokens", "nominees"
  add_foreign_key "tokens", "polls"
end
