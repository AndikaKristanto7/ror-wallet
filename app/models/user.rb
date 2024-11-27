class User < ApplicationRecord
  has_many :debits, foreign_key: "debit_user_id"
  has_many :credits, foreign_key: "credit_user_id"
end
