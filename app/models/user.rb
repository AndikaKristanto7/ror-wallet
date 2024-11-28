class User < ApplicationRecord
  has_many :debits, foreign_key: "debit_user_id"
  has_many :credits, foreign_key: "credit_user_id"
  def get_user_balance
    sum_debit = Debit.where(debit_user_id: self.id,status: ['2']).sum(:debit_amount)
    sum_credit = Credit.where(credit_user_id: self.id,status: ['1','2']).sum(:credit_amount)
    @balance = Integer(sum_debit) - Integer(sum_credit)
  end
  
end
