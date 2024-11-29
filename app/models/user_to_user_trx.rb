class UserToUserTrx < ApplicationRecord
  belongs_to :credit, foreign_key: "utut_credit_id"
  belongs_to :debit, foreign_key: "utut_debit_id"

  def self.create_trx(credit_id,debit_id,trx_type)
    @utut = UserToUserTrx.new
    @utut.utut_credit_id = credit_id
    @utut.utut_debit_id = debit_id
    @utut.status = trx_type
    @utut.save
    @utut
  end
end
