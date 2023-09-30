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

ActiveRecord::Schema[7.1].define(version: 2023_09_30_133220) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "email_enabled", default: true
    t.bigint "owner_id"
    t.boolean "expired", default: false, null: false
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "clients_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "client_id", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "status", default: 0, null: false
    t.string "commentable_type"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "filename"
    t.string "link"
    t.bigint "user_id", null: false
    t.string "comments"
    t.string "documenter_type", null: false
    t.bigint "documenter_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id"
    t.string "action"
    t.integer "eventable_id"
    t.string "eventable_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "action_for_context"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.bigint "account_id", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "critiquable_type", null: false
    t.bigint "critiquable_id", null: false
    t.boolean "published", default: false
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.string "goalable_type", null: false
    t.bigint "goalable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "deadline"
    t.integer "status", default: 0, null: false
    t.bigint "account_id", null: false
    t.boolean "permission", default: false, null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "kbs", force: :cascade do |t|
    t.string "document"
    t.string "link"
    t.bigint "user_id", null: false
    t.bigint "discipline_id"
    t.bigint "job_id"
    t.string "tag"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "comments"
    t.bigint "account_id", null: false
  end

  create_table "message_comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_comments_on_message_id"
    t.index ["user_id"], name: "index_message_comments_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.bigint "space_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.index ["account_id"], name: "index_messages_on_account_id"
    t.index ["space_id"], name: "index_messages_on_space_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.string "notable_type"
    t.bigint "notable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
  end

  create_table "nuggets", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "published", default: false
    t.datetime "published_on", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id", null: false
  end

  create_table "nuggets_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "nugget_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", precision: nil, default: "2021-09-18 06:04:09", null: false
    t.datetime "updated_at", precision: nil, default: "2021-09-18 06:04:09", null: false
  end

  create_table "pay_charges", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at", "default"], name: "pay_customer_owner_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at"
    t.datetime "pause_resumes_at"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "gray", null: false
  end

  create_table "people_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "gray", null: false
  end

  create_table "people_tags_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "people_tag_id", null: false
  end

  create_table "pinned_spaces", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "space_id", null: false
    t.index ["space_id"], name: "index_pinned_spaces_on_space_id"
    t.index ["user_id"], name: "index_pinned_spaces_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "title"
    t.string "message"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "project_observers", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_observers_on_project_id"
    t.index ["user_id"], name: "index_project_observers_on_user_id"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "gray", null: false
  end

  create_table "project_tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "color", default: "gray", null: false
  end

  create_table "project_tags_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "project_tag_id", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "account_id"
    t.bigint "manager_id"
    t.bigint "discipline_id"
    t.string "description"
    t.boolean "archived", default: false
    t.datetime "archived_on", precision: nil
    t.bigint "status_id"
    t.boolean "billable", default: true
    t.decimal "billable_resources", precision: 4, scale: 2
    t.integer "kpi_id"
    t.text "about"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "risks", force: :cascade do |t|
    t.text "body"
    t.boolean "status", default: true, null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "starts_at"
    t.date "ends_at"
    t.integer "occupancy"
    t.boolean "billable", default: true
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "skills_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
  end

  create_table "spaces", force: :cascade do |t|
    t.string "title"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "description"
    t.boolean "archive", default: false
    t.datetime "archive_at"
    t.index ["account_id"], name: "index_spaces_on_account_id"
    t.index ["user_id"], name: "index_spaces_on_user_id"
  end

  create_table "spaces_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "space_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer "attempt_id"
    t.integer "question_id"
    t.integer "option_id"
    t.integer "score", default: 0
    t.boolean "correct"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "survey_attempts", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "actor_id", null: false
    t.integer "survey_id"
    t.boolean "submitted", default: false
    t.boolean "winner"
    t.string "comment"
    t.integer "score"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "participant_type", null: false
  end

  create_table "survey_options", force: :cascade do |t|
    t.integer "question_id"
    t.integer "weight", default: 0
    t.string "text"
    t.boolean "correct"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "survey_participant", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "survey_question_categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer "survey_id"
    t.string "text"
    t.string "description"
    t.string "explanation"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.text "title"
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "templates_assignees", force: :cascade do |t|
    t.bigint "template_id", null: false
    t.string "assignable_type", null: false
    t.bigint "assignable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_labels", force: :cascade do |t|
    t.string "name"
    t.bigint "discipline_id", null: false
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_ticket_labels_on_account_id"
    t.index ["discipline_id"], name: "index_ticket_labels_on_discipline_id"
    t.index ["user_id"], name: "index_ticket_labels_on_user_id"
  end

  create_table "ticket_statuses", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "gray", null: false
    t.index ["account_id"], name: "index_ticket_statuses_on_account_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.bigint "ticket_label_id"
    t.bigint "user_id", null: false
    t.integer "ticket_status_id"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ticketstatus", default: false, null: false
    t.index ["account_id"], name: "index_tickets_on_account_id"
    t.index ["ticket_label_id"], name: "index_tickets_on_ticket_label_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "todos", force: :cascade do |t|
    t.string "title"
    t.date "deadline"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "completed", default: false
    t.bigint "project_id"
    t.bigint "owner_id", null: false
    t.bigint "account_id", null: false
    t.text "body"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "account_id", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "role_id", null: false
    t.integer "discipline_id", null: false
    t.integer "job_id", null: false
    t.bigint "manager_id"
    t.boolean "active", default: true, null: false
    t.datetime "deactivated_on", precision: nil
    t.bigint "status_id"
    t.integer "permission", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "billable", default: true, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.boolean "email_enabled", default: true
    t.integer "kpi_id"
    t.text "about"
    t.string "experience"
    t.string "cv"
  end

  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey1"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey1"
  add_foreign_key "clients", "accounts", name: "clients_account_id_fkey"
  add_foreign_key "clients", "accounts", name: "clients_account_id_fkey1"
  add_foreign_key "comments", "users", name: "comments_user_id_fkey"
  add_foreign_key "disciplines", "accounts", name: "disciplines_account_id_fkey"
  add_foreign_key "disciplines", "accounts", name: "disciplines_account_id_fkey1"
  add_foreign_key "documents", "users", name: "documents_user_id_fkey"
  add_foreign_key "events", "accounts", name: "events_account_id_fkey"
  add_foreign_key "feedbacks", "users", name: "feedbacks_user_id_fkey"
  add_foreign_key "feedbacks", "users", name: "feedbacks_user_id_fkey1"
  add_foreign_key "goals", "accounts", name: "goals_account_id_fkey"
  add_foreign_key "goals", "users", name: "goals_user_id_fkey"
  add_foreign_key "jobs", "accounts", name: "jobs_account_id_fkey"
  add_foreign_key "jobs", "accounts", name: "jobs_account_id_fkey1"
  add_foreign_key "kbs", "accounts", name: "kbs_account_id_fkey"
  add_foreign_key "kbs", "disciplines", name: "kbs_discipline_id_fkey"
  add_foreign_key "kbs", "jobs", name: "kbs_job_id_fkey"
  add_foreign_key "kbs", "users", name: "kbs_user_id_fkey"
  add_foreign_key "message_comments", "messages"
  add_foreign_key "message_comments", "users"
  add_foreign_key "messages", "accounts"
  add_foreign_key "messages", "spaces"
  add_foreign_key "messages", "users"
  add_foreign_key "notes", "users", name: "notes_user_id_fkey"
  add_foreign_key "notes", "users", name: "notes_user_id_fkey1"
  add_foreign_key "nuggets", "accounts", name: "nuggets_account_id_fkey"
  add_foreign_key "nuggets", "skills", name: "nuggets_skill_id_fkey"
  add_foreign_key "nuggets", "users", name: "nuggets_user_id_fkey"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "people_statuses", "accounts", name: "people_statuses_account_id_fkey"
  add_foreign_key "people_statuses", "accounts", name: "people_statuses_account_id_fkey1"
  add_foreign_key "people_tags", "accounts", name: "people_tags_account_id_fkey"
  add_foreign_key "people_tags", "accounts", name: "people_tags_account_id_fkey1"
  add_foreign_key "pinned_spaces", "spaces"
  add_foreign_key "pinned_spaces", "users"
  add_foreign_key "preferences", "accounts", name: "preferences_account_id_fkey"
  add_foreign_key "project_observers", "projects"
  add_foreign_key "project_observers", "users"
  add_foreign_key "project_statuses", "accounts", name: "project_statuses_account_id_fkey"
  add_foreign_key "project_statuses", "accounts", name: "project_statuses_account_id_fkey1"
  add_foreign_key "project_tags", "accounts", name: "project_tags_account_id_fkey"
  add_foreign_key "project_tags", "accounts", name: "project_tags_account_id_fkey1"
  add_foreign_key "projects", "disciplines", name: "projects_discipline_id_fkey"
  add_foreign_key "projects", "disciplines", name: "projects_discipline_id_fkey1"
  add_foreign_key "projects", "project_statuses", column: "status_id", name: "projects_status_id_fkey"
  add_foreign_key "projects", "users", column: "manager_id", name: "projects_manager_id_fkey"
  add_foreign_key "projects", "users", column: "manager_id", name: "projects_manager_id_fkey1"
  add_foreign_key "reports", "users", name: "reports_user_id_fkey"
  add_foreign_key "risks", "projects", name: "risks_project_id_fkey"
  add_foreign_key "risks", "users", name: "risks_user_id_fkey"
  add_foreign_key "roles", "accounts", name: "roles_account_id_fkey"
  add_foreign_key "roles", "accounts", name: "roles_account_id_fkey1"
  add_foreign_key "schedules", "projects", name: "schedules_project_id_fkey"
  add_foreign_key "schedules", "projects", name: "schedules_project_id_fkey1"
  add_foreign_key "schedules", "users", name: "schedules_user_id_fkey"
  add_foreign_key "schedules", "users", name: "schedules_user_id_fkey1"
  add_foreign_key "skills", "accounts", name: "skills_account_id_fkey"
  add_foreign_key "skills", "accounts", name: "skills_account_id_fkey1"
  add_foreign_key "spaces", "accounts"
  add_foreign_key "spaces", "users"
  add_foreign_key "survey_attempts", "users", column: "actor_id", name: "survey_attempts_actor_id_fkey"
  add_foreign_key "survey_question_categories", "accounts", name: "survey_question_categories_account_id_fkey"
  add_foreign_key "survey_surveys", "users", column: "actor_id", name: "survey_surveys_actor_id_fkey"
  add_foreign_key "taggings", "tags", name: "taggings_tag_id_fkey"
  add_foreign_key "tags", "accounts", name: "tags_account_id_fkey"
  add_foreign_key "templates", "accounts", name: "templates_account_id_fkey"
  add_foreign_key "templates", "users", name: "templates_user_id_fkey"
  add_foreign_key "templates_assignees", "templates", name: "templates_assignees_template_id_fkey"
  add_foreign_key "ticket_labels", "accounts"
  add_foreign_key "ticket_labels", "disciplines"
  add_foreign_key "ticket_labels", "users"
  add_foreign_key "ticket_statuses", "accounts"
  add_foreign_key "tickets", "accounts"
  add_foreign_key "tickets", "ticket_labels"
  add_foreign_key "tickets", "ticket_statuses"
  add_foreign_key "tickets", "users"
  add_foreign_key "timesheets", "accounts", name: "timesheets_account_id_fkey"
  add_foreign_key "timesheets", "projects", name: "timesheets_project_id_fkey"
  add_foreign_key "timesheets", "users", name: "timesheets_user_id_fkey"
  add_foreign_key "todos", "accounts", name: "todos_account_id_fkey"
  add_foreign_key "todos", "projects", name: "todos_project_id_fkey"
  add_foreign_key "todos", "users", column: "owner_id", name: "todos_owner_id_fkey"
  add_foreign_key "todos", "users", name: "todos_user_id_fkey"
  add_foreign_key "users", "disciplines", name: "users_discipline_id_fkey"
  add_foreign_key "users", "disciplines", name: "users_discipline_id_fkey1"
  add_foreign_key "users", "jobs", name: "users_job_id_fkey"
  add_foreign_key "users", "jobs", name: "users_job_id_fkey1"
  add_foreign_key "users", "people_statuses", column: "status_id", name: "users_status_id_fkey"
  add_foreign_key "users", "roles", name: "users_role_id_fkey"
  add_foreign_key "users", "roles", name: "users_role_id_fkey1"
  add_foreign_key "users", "users", column: "manager_id", name: "users_manager_id_fkey"
  add_foreign_key "users", "users", column: "manager_id", name: "users_manager_id_fkey1"
end
