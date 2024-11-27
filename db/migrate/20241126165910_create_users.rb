class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.integer :user_acc_number
      t.integer :user_pin
      t.decimal :user_last_balance, precision: 13, scale: 2

      t.timestamps
    end
    add_index :users, :user_acc_number, unique: true
  end
end
