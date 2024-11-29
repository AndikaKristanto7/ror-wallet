class Stock < ApplicationRecord
  has_many :stock_trxes, foreign_key: "st_stock_id"
end
