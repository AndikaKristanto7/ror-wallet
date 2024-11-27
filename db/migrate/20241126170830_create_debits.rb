class CreateDebits < ActiveRecord::Migration[8.0]
  def change
    create_enum :debit_status, ["0", "1", "2"]
    # 0 = cancel/rejected
    # 1 = default/created
    # 2 = confirm/approved
    create_table :debits do |t|
      t.integer :debit_user_id
      t.decimal :debit_amount, precision: 13, scale: 2
      t.enum :status, enum_type: :debit_status, default: "1", null: false
      t.timestamps
    end
  end
end
