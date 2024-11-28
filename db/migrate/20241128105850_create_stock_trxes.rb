class CreateStockTrxes < ActiveRecord::Migration[8.0]
  def change
    create_enum :st_type, ["1", "2"]
    # 1 = credit
    # 2 = debit
    create_table :stock_trxes do |t|
      t.integer :st_stock_id
      t.string :st_trx_id
      t.enum :st_type, enum_type: :st_type, default: nil, null: true
      t.timestamps
    end
  end
end
