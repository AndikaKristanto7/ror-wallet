class UserToUserTrx < ApplicationRecord
  belongs_to :credit, foreign_key: "utut_credit_id"
  belongs_to :debit, foreign_key: "utut_debit_id"
end
