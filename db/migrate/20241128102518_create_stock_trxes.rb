class CreateStockTrxes < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_trxes do |t|
      t.integer :uts_stock_id
      t.integer :uts_trx_id

      t.timestamps
    end
  end
end
