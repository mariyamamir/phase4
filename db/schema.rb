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

ActiveRecord::Schema.define(version: 2019_04_24_124931) do

  create_table "assignments", force: :cascade do |t|
    t.integer "store_id"
    t.integer "employee_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "pay_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "ssn"
    t.date "date_of_birth"
    t.string "phone"
    t.string "role"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flavors", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shift_jobs", force: :cascade do |t|
    t.integer "shift_id"
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_shift_jobs_on_job_id"
    t.index ["shift_id"], name: "index_shift_jobs_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.string "notes"
    t.integer "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_shifts_on_assignment_id"
  end

  create_table "store_flavors", force: :cascade do |t|
    t.integer "store_id"
    t.integer "flavor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flavor_id"], name: "index_store_flavors_on_flavor_id"
    t.index ["store_id"], name: "index_store_flavors_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.float "latitude"
    t.float "longitude"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_users_on_employee_id"
  end

end
