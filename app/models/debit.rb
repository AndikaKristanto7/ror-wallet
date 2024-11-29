class Debit < ApplicationRecord
  belongs_to :user, foreign_key: "debit_user_id"
  has_many :user_to_user_trxes, foreign_key: "utut_debit_id"
  has_many :stock_trx, foreign_key: "st_trx_id"
end
