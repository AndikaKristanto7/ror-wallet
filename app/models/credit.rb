class Credit < ApplicationRecord
  belongs_to :user, foreign_key: "credit_user_id"
  has_many :user_to_user_trxes, foreign_key: "utut_credit_id"
  has_many :stock_trx, foreign_key: "st_trx_id"

  def self.create_trx(user_id,credit_amount,trx_status)
    @credit = Credit.new
    @credit.credit_user_id = user_id
    @credit.credit_amount = credit_amount
    @credit.status = trx_status
    @credit.save
    @credit
  end
end
