class CreateUserToUserTrxes < ActiveRecord::Migration[8.0]
  def change
    create_enum :utut_status, ["0", "1", "2"]
    # 0 = cancel/rejected
    # 1 = default/created
    # 2 = confirm/approved
    create_table :user_to_user_trxes do |t|
      t.integer :utut_credit_id
      t.integer :utut_debit_id
      t.enum :status, enum_type: :utut_status, default: "1", null: false
      t.timestamps
    end
  end
end
