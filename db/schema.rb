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

ActiveRecord::Schema[8.1].define(version: 2026_09_03_144119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "organisations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_organisations_on_email", unique: true
  end

  create_table "timetable_events", force: :cascade do |t|
    t.date "actual_date"
    t.datetime "created_at", null: false
    t.date "entry_date", null: false
    t.date "event_date"
    t.text "notes"
    t.string "plan", null: false
    t.string "plan_event", null: false
    t.string "reference", null: false
    t.bigint "timetable_id", null: false
    t.datetime "updated_at", null: false
    t.index ["timetable_id"], name: "index_timetable_events_on_timetable_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dataset", null: false
    t.text "description", null: false
    t.string "document_url", null: false
    t.string "documentation_url", null: false
    t.date "entry_date", null: false
    t.string "local_planning_authorities", null: false
    t.string "name", null: false
    t.text "notes"
    t.bigint "organisation_id", null: false
    t.string "period_end_date", null: false
    t.string "period_start_date", null: false
    t.string "reference", null: false
    t.integer "required_housing", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_timetables_on_organisation_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.bigint "organisation_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "timetable_events", "timetables"
  add_foreign_key "timetables", "organisations"
  add_foreign_key "users", "organisations"
end
