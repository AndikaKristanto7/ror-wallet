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

ActiveRecord::Schema[8.0].define(version: 2024_11_28_105850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "credit_status", ["0", "1", "2"]
  create_enum "debit_status", ["0", "1", "2"]
  create_enum "st_type", ["1", "2"]
  create_enum "utut_status", ["0", "1", "2"]

  create_table "credits", force: :cascade do |t|
    t.integer "credit_user_id"
    t.decimal "credit_amount", precision: 13, scale: 2
    t.enum "status", default: "1", null: false, enum_type: "credit_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credit_responded_by"
    t.datetime "credit_responded_at"
  end

  create_table "debits", force: :cascade do |t|
    t.integer "debit_user_id"
    t.decimal "debit_amount", precision: 13, scale: 2
    t.enum "status", default: "1", null: false, enum_type: "debit_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "debit_responded_at"
    t.integer "debit_responded_by"
  end

  create_table "stock_trxes", force: :cascade do |t|
    t.integer "st_stock_id"
    t.string "st_trx_id"
    t.enum "st_type", enum_type: "st_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string "stock_identifier"
    t.float "stock_last_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_u_name"
    t.string "team_pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_to_user_trxes", force: :cascade do |t|
    t.integer "utut_credit_id"
    t.integer "utut_debit_id"
    t.enum "status", default: "1", null: false, enum_type: "utut_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.integer "user_acc_number"
    t.integer "user_pin"
    t.decimal "user_last_balance", precision: 13, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_acc_number"], name: "index_users_on_user_acc_number", unique: true
  end
end
