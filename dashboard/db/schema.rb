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

ActiveRecord::Schema.define(version: 20140822202319) do

  create_table "achievement_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.integer  "progress"
    t.datetime "created_at",     null: false
  end

  add_index "achievement_scores", ["user_id", "achievement_id"], name: "index_achievement_progress_on_app_user_and_achievement_id", using: :btree
  add_index "achievement_scores", ["user_id"], name: "index_achievement_progress_on_app_and_user_id", using: :btree

  create_table "achievements", force: true do |t|
    t.string   "name"
    t.integer  "app_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "icon_locked_file_name"
    t.string   "icon_locked_content_type"
    t.integer  "icon_locked_file_size"
    t.datetime "icon_locked_updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "desc"
    t.integer  "points"
    t.integer  "goal"
  end

  add_index "achievements", ["app_id"], name: "index_achievements_on_app_id", using: :btree

  create_table "api_whitelists", force: true do |t|
    t.string "app_key"
    t.string "version", limit: 5
  end

  add_index "api_whitelists", ["app_key", "version"], name: "index_api_whitelists_on_app_key_and_version", using: :btree

  create_table "apps", force: true do |t|
    t.string   "name"
    t.integer  "developer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_key",           limit: 20
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "fbid"
    t.string   "secret_key",        limit: 40
    t.string   "feature_list"
  end

  add_index "apps", ["app_key"], name: "index_apps_on_app_key", unique: true, using: :btree
  add_index "apps", ["developer_id"], name: "index_apps_on_developer_id", using: :btree

  create_table "client_sessions", force: true do |t|
    t.string   "uuid"
    t.string   "fb_id"
    t.string   "google_id"
    t.string   "custom_id"
    t.string   "ok_id"
    t.string   "push_token"
    t.string   "client_db_version"
    t.datetime "client_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "developers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token",  default: "", null: false
  end

  add_index "developers", ["perishable_token"], name: "index_developers_on_perishable_token", using: :btree

  create_table "leaderboards", force: true do |t|
    t.string   "name"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "sort_type",         limit: 20
    t.string   "gamecenter_id"
    t.string   "gpg_id"
    t.integer  "priority",                     default: 100, null: false
  end

  add_index "leaderboards", ["app_id"], name: "index_leaderboards_on_app_id", using: :btree

  create_table "oauth_nonces", force: true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true, using: :btree

  create_table "sandbox_achievement_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.integer  "progress"
    t.datetime "created_at",     null: false
  end

  add_index "sandbox_achievement_scores", ["user_id", "achievement_id"], name: "index_sandbox_achievement_scores_on_user_id_and_achievement_id", using: :btree
  add_index "sandbox_achievement_scores", ["user_id"], name: "index_sandbox_achievement_scores_on_user_id", using: :btree

  create_table "sandbox_client_sessions", force: true do |t|
    t.string   "uuid"
    t.string   "fb_id"
    t.string   "google_id"
    t.string   "custom_id"
    t.string   "ok_id"
    t.string   "push_token"
    t.string   "client_db_version"
    t.datetime "client_created_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "app_id"
  end

  create_table "sandbox_scores", force: true do |t|
    t.integer  "sort_value",            limit: 8, null: false
    t.integer  "user_id"
    t.integer  "leaderboard_id"
    t.datetime "created_at",                      null: false
    t.string   "display_string"
    t.integer  "metadata"
    t.string   "meta_doc_file_name"
    t.string   "meta_doc_content_type"
    t.integer  "meta_doc_file_size"
    t.datetime "meta_doc_updated_at"
  end

  add_index "sandbox_scores", ["leaderboard_id", "sort_value", "created_at"], name: "index_sandbox_scores_composite_1", using: :btree
  add_index "sandbox_scores", ["leaderboard_id", "user_id", "sort_value", "created_at"], name: "index_sandbox_scores_composite_2", using: :btree

  create_table "sandbox_tokens", force: true do |t|
    t.integer  "user_id"
    t.integer  "app_id"
    t.string   "apns_token"
    t.datetime "created_at", null: false
  end

  add_index "sandbox_tokens", ["user_id", "app_id"], name: "index_sandbox_tokens_on_user_id_and_app_id", using: :btree

  create_table "scores", force: true do |t|
    t.integer  "sort_value",            limit: 8, null: false
    t.integer  "user_id"
    t.integer  "leaderboard_id"
    t.datetime "created_at"
    t.string   "display_string"
    t.integer  "metadata"
    t.string   "meta_doc_file_name"
    t.string   "meta_doc_content_type"
    t.integer  "meta_doc_file_size"
    t.datetime "meta_doc_updated_at"
  end

  add_index "scores", ["leaderboard_id", "sort_value", "created_at"], name: "index_scores_composite_1", using: :btree
  add_index "scores", ["leaderboard_id", "user_id", "sort_value", "created_at"], name: "index_scores_composite_2", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "app_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["app_id"], name: "index_subscriptions_on_app_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tokens", force: true do |t|
    t.integer  "user_id"
    t.integer  "app_id"
    t.string   "apns_token"
    t.datetime "created_at", null: false
  end

  add_index "tokens", ["user_id", "app_id"], name: "index_tokens_on_user_id_and_app_id", using: :btree

  create_table "turns", force: true do |t|
    t.string   "uuid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_doc_file_name"
    t.string   "meta_doc_content_type"
    t.integer  "meta_doc_file_size"
    t.datetime "meta_doc_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "nick"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "developer_id"
    t.string   "twitter_id",    limit: 40
    t.string   "fb_id",         limit: 40
    t.string   "custom_id",     limit: 40
    t.string   "google_id",     limit: 40
    t.string   "gamecenter_id", limit: 40
  end

  add_index "users", ["custom_id"], name: "index_users_on_custom_id", using: :btree
  add_index "users", ["developer_id"], name: "index_users_on_developer_id", using: :btree
  add_index "users", ["fb_id"], name: "index_users_on_fb_id", using: :btree
  add_index "users", ["gamecenter_id"], name: "index_users_on_gamecenter_id", using: :btree
  add_index "users", ["google_id"], name: "index_users_on_google_id", using: :btree
  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id", using: :btree

end
