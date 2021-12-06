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

ActiveRecord::Schema.define(version: 2021_11_29_141322) do

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

  create_table "documents", force: :cascade do |t|
    t.string "filename"
    t.string "link"
    t.bigint "user_id", null: false
    t.string "comments"
    t.string "documenter_type", null: false
    t.bigint "documenter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["documenter_type", "documenter_id"], name: "index_documents_on_documenter"
    t.index ["user_id"], name: "index_documents_on_user_id"
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
    t.boolean "permission", default: false, null: false
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

  create_table "kbs", force: :cascade do |t|
    t.string "document"
    t.string "link"
    t.bigint "user_id", null: false
    t.bigint "discipline_id"
    t.bigint "job_id"
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comments"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_kbs_on_account_id"
    t.index ["discipline_id"], name: "index_kbs_on_discipline_id"
    t.index ["job_id"], name: "index_kbs_on_job_id"
    t.index ["user_id"], name: "index_kbs_on_user_id"
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

  create_table "nuggets", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "published", default: false
    t.datetime "published_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_nuggets_on_account_id"
    t.index ["skill_id"], name: "index_nuggets_on_skill_id"
    t.index ["user_id"], name: "index_nuggets_on_user_id"
  end

  create_table "nuggets_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "nugget_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", default: "2021-09-18 06:04:09", null: false
    t.datetime "updated_at", default: "2021-09-18 06:04:09", null: false
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
    t.integer "kpi_id"
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["discipline_id"], name: "index_projects_on_discipline_id"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
    t.index ["status_id"], name: "index_projects_on_status_id"
  end

  create_table "projects_skills", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "skill_id", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.bigint "user_id", null: false
    t.boolean "submitted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "risks", force: :cascade do |t|
    t.text "body"
    t.boolean "status", default: true, null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_risks_on_project_id"
    t.index ["user_id"], name: "index_risks_on_user_id"
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
    t.boolean "billable", default: true
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

  create_table "skills_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer "attempt_id"
    t.integer "question_id"
    t.integer "option_id"
    t.integer "score", default: 0
    t.boolean "correct"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "survey_attempts", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "actor_id", null: false
    t.integer "survey_id"
    t.boolean "submitted", default: false
    t.boolean "winner"
    t.string "comment"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "participant_type", null: false
    t.index ["actor_id"], name: "index_survey_attempts_on_actor_id"
    t.index ["participant_id"], name: "index_survey_attempts_on_participant_id"
  end

  create_table "survey_options", force: :cascade do |t|
    t.integer "question_id"
    t.integer "weight", default: 0
    t.string "text"
    t.boolean "correct"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "survey_participant", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "survey_question_categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_survey_question_categories_on_account_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer "survey_id"
    t.string "text"
    t.string "description"
    t.string "explanation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "question_category_id"
  end

  create_table "survey_surveys", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "account_id", default: 0
    t.integer "survey_for", default: 0
    t.integer "attempts_number", default: 0
    t.boolean "finished", default: false
    t.boolean "active", default: false
    t.integer "winning_score", default: 0
    t.bigint "actor_id", null: false
    t.integer "survey_type", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["actor_id"], name: "index_survey_surveys_on_actor_id"
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
    t.text "body"
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
    t.integer "kpi_id"
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
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey"
  add_foreign_key "clients", "accounts"
  add_foreign_key "clients", "accounts", name: "clients_account_id_fkey"
  add_foreign_key "comments", "goals"
  add_foreign_key "comments", "users"
  add_foreign_key "disciplines", "accounts"
  add_foreign_key "disciplines", "accounts", name: "disciplines_account_id_fkey"
  add_foreign_key "documents", "users"
  add_foreign_key "events", "accounts"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "feedbacks", "users", name: "feedbacks_user_id_fkey"
  add_foreign_key "goals", "accounts"
  add_foreign_key "goals", "users"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "jobs", "accounts", name: "jobs_account_id_fkey"
  add_foreign_key "kbs", "accounts"
  add_foreign_key "kbs", "disciplines"
  add_foreign_key "kbs", "jobs"
  add_foreign_key "kbs", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", name: "notes_user_id_fkey"
  add_foreign_key "nuggets", "accounts"
  add_foreign_key "nuggets", "skills"
  add_foreign_key "nuggets", "users"
  add_foreign_key "people_statuses", "accounts"
  add_foreign_key "people_statuses", "accounts", name: "people_statuses_account_id_fkey"
  add_foreign_key "people_tags", "accounts"
  add_foreign_key "people_tags", "accounts", name: "people_tags_account_id_fkey"
  add_foreign_key "project_statuses", "accounts"
  add_foreign_key "project_statuses", "accounts", name: "project_statuses_account_id_fkey"
  add_foreign_key "project_tags", "accounts"
  add_foreign_key "project_tags", "accounts", name: "project_tags_account_id_fkey"
  add_foreign_key "projects", "disciplines"
  add_foreign_key "projects", "disciplines", name: "projects_discipline_id_fkey"
  add_foreign_key "projects", "project_statuses", column: "status_id"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "reports", "users"
  add_foreign_key "risks", "projects"
  add_foreign_key "risks", "users"
  add_foreign_key "roles", "accounts"
  add_foreign_key "roles", "accounts", name: "roles_account_id_fkey"
  add_foreign_key "schedules", "projects"
  add_foreign_key "schedules", "projects", name: "schedules_project_id_fkey"
  add_foreign_key "schedules", "users"
  add_foreign_key "schedules", "users", name: "schedules_user_id_fkey"
  add_foreign_key "skills", "accounts"
  add_foreign_key "skills", "accounts", name: "skills_account_id_fkey"
  add_foreign_key "survey_attempts", "users", column: "actor_id"
  add_foreign_key "survey_question_categories", "accounts"
  add_foreign_key "survey_surveys", "users", column: "actor_id"
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
  add_foreign_key "users", "disciplines", name: "users_discipline_id_fkey"
  add_foreign_key "users", "jobs"
  add_foreign_key "users", "jobs", name: "users_job_id_fkey"
  add_foreign_key "users", "people_statuses", column: "status_id"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "roles", name: "users_role_id_fkey"
  add_foreign_key "users", "users", column: "manager_id"
  add_foreign_key "users", "users", column: "manager_id", name: "users_manager_id_fkey"
end
