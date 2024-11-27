class Credit < ApplicationRecord
  belongs_to :user, foreign_key: "credit_user_id"
  has_many :user_to_user_trxes, foreign_key: "utut_credit_id"
end
