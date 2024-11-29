class Debit < ApplicationRecord
  belongs_to :user, foreign_key: "debit_user_id"
  has_many :user_to_user_trxes, foreign_key: "utut_debit_id"
  has_many :stock_trx, foreign_key: "st_trx_id"

  def self.create_trx(user_id,debit_amount,trx_status)
    @debit = Debit.new
    @debit.debit_user_id = user_id
    @debit.debit_amount = debit_amount
    @debit.status = trx_status
    @debit.save
    @debit
  end
end
