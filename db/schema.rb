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

ActiveRecord::Schema[8.1].define(version: 2026_10_23_125414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_organisations_on_email", unique: true
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "organisation_id", null: false
    t.string "name"
    t.string "reference"
    t.string "dataset"
    t.text "description"
    t.text "notes"
    t.string "status", default: "draft", null: false
    t.string "document_url"
    t.string "documentation_url"
    t.string "local_planning_authorities"
    t.integer "required_housing"
    t.date "entry_date"
    t.integer "period_start_date"
    t.integer "period_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_plans_on_organisation_id"
    t.index ["status"], name: "index_plans_on_status"
  end

  create_table "timetable_events", force: :cascade do |t|
    t.bigint "timetable_id", null: false
    t.string "reference"
    t.string "plan_event"
    t.string "plan"
    t.date "event_date"
    t.date "actual_date"
    t.date "entry_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "draft", null: false
    t.index ["status"], name: "index_timetable_events_on_status"
    t.index ["timetable_id"], name: "index_timetable_events_on_timetable_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.bigint "organisation_id", null: false
    t.string "reference"
    t.string "local_planning_authorities"
    t.string "name"
    t.string "dataset"
    t.text "description"
    t.string "documentation_url"
    t.string "document_url"
    t.date "entry_date"
    t.integer "required_housing"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "draft", null: false
    t.bigint "plan_id", null: false
    t.integer "period_start_year"
    t.integer "period_end_year"
    t.index ["organisation_id"], name: "index_timetables_on_organisation_id"
    t.index ["plan_id"], name: "index_timetables_on_plan_id", unique: true
    t.index ["status"], name: "index_timetables_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organisation_id"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "plans", "organisations"
  add_foreign_key "timetable_events", "timetables"
  add_foreign_key "timetables", "organisations"
  add_foreign_key "timetables", "plans"
  add_foreign_key "users", "organisations"
end
