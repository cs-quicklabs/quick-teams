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

ActiveRecord::Schema.define(version: 2021_02_22_072859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_clients_on_account_id"
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_disciplines_on_account_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_jobs_on_account_id"
  end

  create_table "people_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_people_statuses_on_account_id"
  end

  create_table "people_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_people_tags_on_account_id"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_project_statuses_on_account_id"
  end

  create_table "project_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_project_tags_on_account_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.bigint "manager_id"
    t.bigint "discipline_id"
    t.string "description"
    t.date "starts_at"
    t.date "ends_at"
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["discipline_id"], name: "index_projects_on_discipline_id"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_roles_on_account_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "starts_at"
    t.date "ends_at"
    t.integer "occupancy"
    t.index ["project_id"], name: "index_schedules_on_project_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_skills_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.string "first_name"
    t.string "last_name"
    t.bigint "role_id"
    t.bigint "discipline_id"
    t.bigint "job_id"
    t.bigint "manager_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["discipline_id"], name: "index_users_on_discipline_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["job_id"], name: "index_users_on_job_id"
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "clients", "accounts"
  add_foreign_key "disciplines", "accounts"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "people_statuses", "accounts"
  add_foreign_key "people_tags", "accounts"
  add_foreign_key "project_statuses", "accounts"
  add_foreign_key "project_tags", "accounts"
  add_foreign_key "projects", "disciplines"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "roles", "accounts"
  add_foreign_key "schedules", "projects"
  add_foreign_key "schedules", "users"
  add_foreign_key "skills", "accounts"
  add_foreign_key "users", "disciplines"
  add_foreign_key "users", "jobs"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "users", column: "manager_id"
end
