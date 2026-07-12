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

ActiveRecord::Schema[8.0].define(version: 2026_07_12_240000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blogs", force: :cascade do |t|
    t.string "slug_en"
    t.string "slug_ar"
    t.string "title_ar"
    t.string "title_en"
    t.text "excerpt_ar"
    t.text "excerpt_en"
    t.string "meta_title_ar"
    t.string "meta_title_en"
    t.text "meta_description_ar"
    t.text "meta_description_en"
    t.string "alt_ar"
    t.string "alt_en"
    t.string "category"
    t.boolean "is_published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_published"], name: "index_blogs_on_is_published"
    t.index ["slug_ar"], name: "index_blogs_on_slug_ar", unique: true
    t.index ["slug_en"], name: "index_blogs_on_slug_en", unique: true
  end

  create_table "bridal_leads", force: :cascade do |t|
    t.string "email", null: false
    t.date "wedding_date"
    t.string "preferred_locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_bridal_leads_on_created_at"
  end

  create_table "contents", force: :cascade do |t|
    t.string "parentable_type", null: false
    t.bigint "parentable_id", null: false
    t.string "key", null: false
    t.string "label"
    t.string "hint"
    t.text "value_ar"
    t.text "value_en"
    t.string "content_type", default: "text", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alt_ar"
    t.string "alt_en"
    t.index ["parentable_type", "parentable_id", "key"], name: "index_contents_on_parent_and_key", unique: true
    t.index ["parentable_type", "parentable_id"], name: "index_contents_on_parentable"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name", null: false
    t.string "mobile", null: false
    t.string "email"
    t.string "preferred_locale"
    t.string "persona"
    t.string "preferred_time"
    t.string "source_codeword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_inquiries_on_created_at"
  end

  create_table "protocols", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "position", default: 0, null: false
    t.boolean "trademark", default: false, null: false
    t.string "persona"
    t.string "codeword"
    t.string "name_ar"
    t.string "name_en"
    t.text "promise_ar"
    t.text "promise_en"
    t.string "duration_ar"
    t.string "duration_en"
    t.string "meta_ar"
    t.string "meta_en"
    t.text "who_for_ar"
    t.text "who_for_en"
    t.text "scope_ar"
    t.text "scope_en"
    t.text "excludes_ar"
    t.text "excludes_en"
    t.jsonb "stages", default: [], null: false
    t.jsonb "faqs", default: [], null: false
    t.jsonb "patient_story", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_protocols_on_position"
    t.index ["slug"], name: "index_protocols_on_slug", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.string "page", null: false
    t.string "kind", null: false
    t.string "label"
    t.integer "position", default: 0, null: false
    t.jsonb "settings", default: {}, null: false
    t.jsonb "items", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page", "kind"], name: "index_sections_on_page_and_kind", unique: true
    t.index ["page"], name: "index_sections_on_page"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", default: "editor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
