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

ActiveRecord::Schema.define(version: 20170218210439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.float    "balance"
    t.integer  "status"
    t.bigint   "account_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
    t.integer  "predefined"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id", using: :btree
  end

  create_table "friends", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.index ["friend_id", "user_id"], name: "index_friends_on_friend_id_and_user_id", unique: true, using: :btree
    t.index ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true, using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "status"
    t.integer  "admin_status"
    t.datetime "start"
    t.datetime "finish"
    t.integer  "type"
    t.float    "amount"
    t.integer  "account_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["account_id"], name: "index_transactions_on_account_id", using: :btree
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "transaction_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["account_id"], name: "index_transfers_on_account_id", using: :btree
    t.index ["transaction_id"], name: "index_transfers_on_transaction_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "admins", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transfers", "accounts"
  add_foreign_key "transfers", "transactions"
end
