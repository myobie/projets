# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140518201150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "digest"
    t.datetime "expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_tokens", ["digest"], name: "index_access_tokens_on_digest", using: :btree

  create_table "accounts", force: true do |t|
    t.string   "name",                    null: false
    t.integer  "admin_ids",  default: [],              array: true
    t.integer  "owner_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["admin_ids"], name: "index_accounts_on_admin_ids", using: :gin
  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id", using: :btree

  create_table "attachments", force: true do |t|
    t.string   "original_filename", null: false
    t.integer  "size",              null: false
    t.string   "content_type",      null: false
    t.string   "key",               null: false
    t.integer  "attachable_id",     null: false
    t.string   "attachable_type",   null: false
    t.integer  "user_id",           null: false
    t.integer  "upload_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], name: "index_attachments_on_attachable_id_and_attachable_type", using: :btree
  add_index "attachments", ["upload_id"], name: "index_attachments_on_upload_id", using: :btree
  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content",          null: false
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.integer  "user_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "discussions", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussions", ["project_id"], name: "index_discussions_on_project_id", using: :btree
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name",                    null: false
    t.integer  "account_id",              null: false
    t.integer  "member_ids", default: [],              array: true
    t.integer  "owner_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["account_id"], name: "index_projects_on_account_id", using: :btree
  add_index "projects", ["member_ids"], name: "index_projects_on_member_ids", using: :gin
  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "uploads", force: true do |t|
    t.string   "key",                        null: false
    t.string   "state",      default: "new", null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",      null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
