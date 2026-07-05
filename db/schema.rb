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

ActiveRecord::Schema[8.0].define(version: 2026_07_05_110001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
end
