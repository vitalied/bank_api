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

ActiveRecord::Schema[7.0].define(version: 2022_09_02_222807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "iban", limit: 34, null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_accounts_on_created_by_id"
    t.index ["customer_id"], name: "index_accounts_on_customer_id"
    t.index ["iban"], name: "index_accounts_on_iban", unique: true
    t.index ["updated_by_id"], name: "index_accounts_on_updated_by_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_customers_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "transaction_type", limit: 10, null: false
    t.string "sender_iban", limit: 34, null: false
    t.string "receiver_iban", limit: 34, null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "notes"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["created_by_id"], name: "index_transactions_on_created_by_id"
    t.index ["receiver_iban"], name: "index_transactions_on_receiver_iban"
    t.index ["sender_iban"], name: "index_transactions_on_sender_iban"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
    t.index ["updated_by_id"], name: "index_transactions_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "access_token", limit: 40, null: false
    t.string "username", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_users_on_access_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "accounts", "customers"
  add_foreign_key "accounts", "users", column: "created_by_id"
  add_foreign_key "accounts", "users", column: "updated_by_id"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "users", column: "created_by_id"
  add_foreign_key "transactions", "users", column: "updated_by_id"
end
