require 'constants'
class User < ApplicationRecord
  has_many :debits, foreign_key: "debit_user_id"
  has_many :credits, foreign_key: "credit_user_id"

  def get_user_balance
    sum_debit = Debit.where(debit_user_id: self.id,status: [Constants::TRX_STATUS_APPROVED]).sum(:debit_amount)
    sum_credit = Credit.where(credit_user_id: self.id,status: [Constants::TRX_STATUS_DEFAULT,Constants::TRX_STATUS_APPROVED]).sum(:credit_amount)
    @balance = Integer(sum_debit) - Integer(sum_credit)
  end

  def get_stock_amount_share_owned(stock_id)
    buy_share_stock = Credit.joins('INNER JOIN "stock_trxes" ON "stock_trxes"."st_trx_id" = "credits"."id"').where(credit_user_id: self.id,status: [Constants::TRX_STATUS_APPROVED],"stock_trxes.st_type": [Constants::TRX_TYPE_CREDIT],"stock_trxes.st_stock_id": stock_id).sum("stock_trxes.st_amount_share")
    sell_share_stock = Debit.joins('INNER JOIN "stock_trxes" ON "stock_trxes"."st_trx_id" = "debits"."id"').where(debit_user_id: self.id,status: [Constants::TRX_STATUS_APPROVED],"stock_trxes.st_type": [Constants::TRX_TYPE_DEBIT],"stock_trxes.st_stock_id": stock_id).sum("stock_trxes.st_amount_share")
    @amount_share_owned = Integer(buy_share_stock) - Integer(sell_share_stock)
  end
  
end
