class CreateCredits < ActiveRecord::Migration[8.0]
  def change
    create_enum :credit_status, ["0", "1", "2"]
    # 0 = cancel/rejected
    # 1 = default/created
    # 2 = confirm/approved

    create_table :credits do |t|
      t.integer :credit_user_id
      t.decimal :credit_amount, precision: 13, scale: 2
      t.enum :status, enum_type: :credit_status, default: "1", null: false
      t.timestamps
    end
  end
end
