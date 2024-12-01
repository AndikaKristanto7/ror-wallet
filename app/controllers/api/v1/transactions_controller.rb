require 'constants'
class Api::V1::TransactionsController < ApplicationController
  before_action :get_user
  before_action :get_user_balance, only:[:withdraw,:transfer,:buy_stock]
  before_action :get_stock, only:[:buy_stock,:sell_stock]
  before_action :get_user_to_transfer, only:[:transfer]

  def deposit
    @debit = Debit.create_trx(@user.id,params[:deposit_amount],Constants::TRX_STATUS_DEFAULT)
    render json: @debit
  end

  def get_all_debit_trx
    user_id = @user.id
    @debit = Debit.where(debit_user_id: user_id).all
    render json: @debit
  end

  def withdraw
    withdraw_amount = params[:withdraw_amount]
    if((@balance - withdraw_amount) < 0)
      render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
    else
      @credit = Credit.create_trx(@user.id,withdraw_amount,Constants::TRX_STATUS_DEFAULT)
      @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)
      render json: @user
    end
  end

  def get_all_credit_trx
    user_id = @user.id
    @credit = Credit.where(credit_user_id: user_id).all
    render json: @credit
  end
  
  def transfer
    @transfer_amount = params[:transfer_amount]
    if((@balance - @transfer_amount) < 0)
      render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
    else
      do_user_to_user_trx()
      render json: @user
    end
  end

  def buy_stock
    @buy_share_amount = params[:buy_share_amount]
    @total_price = @stock.stock_last_price * @buy_share_amount   
    if((@balance - @total_price) < 0)
      render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
    else
      @trx_type = Constants::TRX_TYPE_CREDIT
      @amount_share = @buy_share_amount
      do_stock_trx(@trx_type,@total_price,@amount_share)
      render json: @st
    end
  end

  def sell_stock
    @sell_share_amount = Integer(params[:sell_share_amount])
    @amount_share_owned = @user.get_stock_amount_share_owned(@stock.id) == nil ? 0 :  @user.get_stock_amount_share_owned(@stock.id)
    if( (@amount_share_owned - @sell_share_amount) <= 0)
      render json: {'code': "error",'msg': "insufficient share owned"}, status: :unprocessable_entity
    else
      @total_price = @stock.stock_last_price * @sell_share_amount   
      @trx_type = Constants::TRX_TYPE_DEBIT
      @amount_share = @buy_share_amount
      do_stock_trx(@trx_type,@total_price,@amount_share) 
      render json: @st
    end
  end

  def get_buy_stock_trx
    @st = StockTrx.joins('INNER JOIN "credits" "credit" ON "credit"."id" = "stock_trxes"."st_trx_id"').where("credit.credit_user_id": @user.id,st_type: [Constants::TRX_TYPE_CREDIT]).all
    render json: @st
  end

  def get_sell_stock_trx
    @st = StockTrx.joins('INNER JOIN "debits" "debit" ON "debit"."id" = "stock_trxes"."st_trx_id"').where("debit.debit_user_id": @user.id,st_type: [Constants::TRX_TYPE_DEBIT]).all
    render json: @st
  end

  private

  def get_user
    @user = User.where(user_acc_number: params[:acc_number],user_pin: Integer(params[:pin])).take
    if @user == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    end
  end

  def get_user_to_transfer
    @transfer_to = User.where(user_acc_number: params[:transfer_to]).take
    if @transfer_to == nil
      render json: {'code': "error",'msg': "Acc number not found"}, status: :unprocessable_entity
    end
  end

  def get_stock
    @stock = Stock.where(stock_identifier: params['stock_identifier']).take
    if @stock == nil
      render json: {'code':"error","msg":"stock not found"}, status:404
    end
  end

  def do_user_to_user_trx 
    @credit = Credit.create_trx(@user.id,@transfer_amount,Constants::TRX_STATUS_APPROVED)
    @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)

    @debit = Debit.create_trx(@user.id,@transfer_amount,Constants::TRX_STATUS_APPROVED)

    @utut = UserToUserTrx.create_trx(@credit.id,@debit.id,Constants::TRX_STATUS_APPROVED)

    transfer_to_last_balance = @transfer_to.user_last_balance == nil ? 0 : @transfer_to.user_last_balance
    @transfer_to.update(user_last_balance: transfer_to_last_balance + @transfer_amount)
  end 

  def do_stock_trx(trx_type, total_price, amount_share)
    if trx_type == Constants::TRX_TYPE_CREDIT
      @credit = Credit.create_trx(@user.id,total_price,Constants::TRX_STATUS_DEFAULT)
      @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)
      trx_id = @credit.id
      @st = insert_stock_trx(trx_type, amount_share,trx_id)
      
    end

    if trx_type == Constants::TRX_TYPE_DEBIT
      @debit = Debit.create_trx(@user.id,total_price,Constants::TRX_STATUS_DEFAULT)
      trx_id = @debit.id
      @st = insert_stock_trx(trx_type, amount_share,trx_id)
    end
  end
  
  def insert_stock_trx(trx_type, amount_share,trx_id)
    @st = StockTrx.create_trx(@stock.id,trx_id,trx_type,amount_share)
    @st
  end

  def get_user_balance
    @balance = @user.get_user_balance
  end
end
