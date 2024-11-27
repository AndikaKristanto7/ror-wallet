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

ActiveRecord::Schema[8.0].define(version: 2024_11_26_172502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "credit_status", ["0", "1", "2"]
  create_enum "debit_status", ["0", "1", "2"]
  create_enum "utut_status", ["0", "1", "2"]

  create_table "credits", force: :cascade do |t|
    t.integer "credit_user_id"
    t.decimal "credit_amount", precision: 13, scale: 2
    t.enum "status", default: "1", null: false, enum_type: "credit_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "debits", force: :cascade do |t|
    t.integer "debit_user_id"
    t.decimal "debit_amount", precision: 13, scale: 2
    t.enum "status", default: "1", null: false, enum_type: "debit_status"
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
