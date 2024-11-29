class StockTrx < ApplicationRecord
  belongs_to :stock, foreign_key: "st_stock_id"
end
