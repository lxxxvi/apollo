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

ActiveRecord::Schema.define(version: 2018_10_20_082601) do

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
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_id"], name: "ak_polls_custom_id", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.string "value", null: false
    t.bigint "poll_id", null: false
    t.bigint "nominee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nominee_id"], name: "index_tokens_on_nominee_id"
    t.index ["poll_id", "value"], name: "ak_tokens_poll_id_value", unique: true
    t.index ["poll_id"], name: "index_tokens_on_poll_id"
  end

  add_foreign_key "tokens", "nominees"
  add_foreign_key "tokens", "polls"
end
