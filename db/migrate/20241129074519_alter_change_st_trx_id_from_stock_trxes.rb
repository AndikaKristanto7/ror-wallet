class AlterChangeStTrxIdFromStockTrxes < ActiveRecord::Migration[8.0]
  def up
    change_column :stock_trxes, :st_trx_id, 'integer USING CAST(st_trx_id AS integer)'
  end

  def down
      change_column :stock_trxes, :st_trx_id, :string
  end
end
