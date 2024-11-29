class AddStAmountShareToStockTrxes < ActiveRecord::Migration[8.0]
  def change
    add_column :stock_trxes, :st_amount_share, :integer
  end
end
