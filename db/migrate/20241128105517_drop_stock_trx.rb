class DropStockTrx < ActiveRecord::Migration[8.0]
  def change
    drop_table :stock_trxes
  end
end
