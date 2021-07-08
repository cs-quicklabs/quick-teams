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

ActiveRecord::Schema.define(version: 2021_06_30_140455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "email_enabled", default: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_clients_on_account_id"
    t.index ["email"], name: "index_clients_on_email"
  end

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["goal_id"], name: "index_comments_on_goal_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_disciplines_on_account_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id"
    t.string "action"
    t.integer "eventable_id"
    t.string "eventable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "action_for_context"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "critiquable_type", null: false
    t.bigint "critiquable_id", null: false
    t.boolean "published", default: false
    t.index ["critiquable_type", "critiquable_id"], name: "index_feedbacks_on_critiquable"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.string "goalable_type", null: false
    t.bigint "goalable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "deadline"
    t.integer "status", default: 0, null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_goals_on_account_id"
    t.index ["goalable_type", "goalable_id"], name: "index_goals_on_goalable"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_jobs_on_account_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.string "notable_type"
    t.bigint "notable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "people_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "gray", null: false
    t.index ["account_id"], name: "index_people_statuses_on_account_id"
  end

  create_table "people_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "gray", null: false
    t.index ["account_id"], name: "index_people_tags_on_account_id"
  end

  create_table "people_tags_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "people_tag_id", null: false
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "gray", null: false
    t.index ["account_id"], name: "index_project_statuses_on_account_id"
  end

  create_table "project_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "gray", null: false
    t.index ["account_id"], name: "index_project_tags_on_account_id"
  end

  create_table "project_tags_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "project_tag_id", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.bigint "manager_id"
    t.bigint "discipline_id"
    t.string "description"
    t.boolean "archived", default: false
    t.datetime "archived_on"
    t.bigint "status_id"
    t.boolean "billable", default: true
    t.decimal "billable_resources", precision: 4, scale: 2
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["discipline_id"], name: "index_projects_on_discipline_id"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
    t.index ["status_id"], name: "index_projects_on_status_id"
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
<<<<<<< HEAD
    t.boolean "billable", default: true
=======
    t.boolean "billable"
>>>>>>> 2fef2d14b613f9d1d5d4626090f1a8e06c66219a
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

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_tags_on_account_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.decimal "hours", precision: 4, scale: 2, default: "0.0", null: false
    t.date "date", null: false
    t.string "description", null: false
    t.boolean "billed", default: false, null: false
    t.boolean "billable", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_timesheets_on_account_id"
    t.index ["project_id"], name: "index_timesheets_on_project_id"
    t.index ["user_id"], name: "index_timesheets_on_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "title"
    t.date "deadline"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "completed", default: false
    t.bigint "project_id"
    t.bigint "owner_id", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_todos_on_account_id"
    t.index ["owner_id"], name: "index_todos_on_owner_id"
    t.index ["project_id"], name: "index_todos_on_project_id"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "role_id", null: false
    t.integer "discipline_id", null: false
    t.integer "job_id", null: false
    t.bigint "manager_id"
    t.boolean "active", default: true, null: false
    t.datetime "deactivated_on"
    t.bigint "status_id"
    t.integer "permission", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "billable", default: true, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "email_enabled", default: true
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["discipline_id"], name: "index_users_on_discipline_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["job_id"], name: "index_users_on_job_id"
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["status_id"], name: "index_users_on_status_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clients", "accounts"
  add_foreign_key "comments", "goals"
  add_foreign_key "comments", "users"
  add_foreign_key "disciplines", "accounts"
  add_foreign_key "events", "accounts"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "goals", "accounts"
  add_foreign_key "goals", "users"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "notes", "users"
  add_foreign_key "people_statuses", "accounts"
  add_foreign_key "people_tags", "accounts"
  add_foreign_key "project_statuses", "accounts"
  add_foreign_key "project_tags", "accounts"
  add_foreign_key "projects", "disciplines"
  add_foreign_key "projects", "project_statuses", column: "status_id"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "roles", "accounts"
  add_foreign_key "schedules", "projects"
  add_foreign_key "schedules", "users"
  add_foreign_key "skills", "accounts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "accounts"
  add_foreign_key "timesheets", "accounts"
  add_foreign_key "timesheets", "projects"
  add_foreign_key "timesheets", "users"
  add_foreign_key "todos", "accounts"
  add_foreign_key "todos", "projects"
  add_foreign_key "todos", "users"
  add_foreign_key "todos", "users", column: "owner_id"
  add_foreign_key "users", "disciplines"
  add_foreign_key "users", "jobs"
  add_foreign_key "users", "people_statuses", column: "status_id"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "users", column: "manager_id"
end
