class StockTrx < ApplicationRecord
  belongs_to :stock, foreign_key: "st_stock_id"

  def self.create_trx(stock_id,trx_id,trx_type,amount_share)
    @st = StockTrx.new 
    @st.st_stock_id = stock_id
    @st.st_trx_id = trx_id
    @st.st_type = trx_type
    @st.st_amount_share = amount_share
    @st.save
    @st
  end
end
