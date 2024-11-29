class Api::V1::TransactionsController < ApplicationController
  before_action :get_user
  before_action :get_user_balance, only:[:withdraw,:transfer,:buy_stock]
  before_action :get_stock, only:[:buy_stock,:sell_stock]

  def deposit
    @debit = Debit.new
    @debit.debit_user_id = @user.id
    @debit.debit_amount = params[:deposit_amount]
    @debit.status = 1
    @debit.save
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
      @credit = Credit.new
      @credit.credit_user_id = @user.id
      @credit.credit_amount = withdraw_amount
      @credit.status = 1
      @credit.save
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
    @transfer_to = User.where(user_acc_number: params[:transfer_to]).take
    if @transfer_to == nil
      render json: {'code': "error",'msg': "Acc number not found"}, status: :unprocessable_entity
    else
      @transfer_amount = params[:transfer_amount]
      if((@balance - @transfer_amount) < 0)
        render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
      else
        do_user_to_user_trx()
        render json: @user
      end
    end
  end

  def buy_stock
    @buy_share_amount = params[:buy_share_amount]
    @total_price = @stock.stock_last_price * @buy_share_amount   
    if((@balance - @total_price) < 0)
      render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
    else
      @trx_type = 1
      @amount_share = @buy_share_amount
      do_stock_trx(@trx_type,@total_price,@amount_share)
    end
  end

  def sell_stock
    @sell_share_amount = Integer(params[:sell_share_amount])
    @amount_share_owned = @user.get_stock_amount_share_owned(@stock.id) == nil ? 0 :  @user.get_stock_amount_share_owned(@stock.id)
    p @amount_share_owned
    if( (@amount_share_owned - @sell_share_amount) <= 0)
      render json: {'code': "error",'msg': "insufficient share owned"}, status: :unprocessable_entity
    else
      @total_price = @stock.stock_last_price * @sell_share_amount   
      @trx_type = 2
      @amount_share = @buy_share_amount
      do_stock_trx(@trx_type,@total_price,@amount_share) 
      render json: @st
    end
  end

  def get_buy_stock_trx
    @st = StockTrx.joins('INNER JOIN "credits" "credit" ON "credit"."id" = "stock_trxes"."st_trx_id"').where("credit.credit_user_id": @user.id,st_type: ['1']).all
    @amount_share_owned = @user.get_stock_amount_share_owned(4) == nil ? 0 :  @user.get_stock_amount_share_owned(4)
    p @amount_share_owned
    render json: @st
  end

  def get_sell_stock_trx
    @st = StockTrx.joins('INNER JOIN "debits" "debit" ON "debit"."id" = "stock_trxes"."st_trx_id"').where("debit.debit_user_id": @user.id,st_type: ['2']).all
    render json: @st
  end

  private

  def get_user
    @user = User.where(user_acc_number: params[:acc_number],user_pin: Integer(params[:pin])).take
    if @user == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    end
  end

  def get_stock
    @stock = Stock.where(stock_identifier: params['stock_identifier']).take
    if @stock == nil
      render json: {'code':"error","msg":"stock not found"}, status:404
    end
  end

  def do_user_to_user_trx 
    @credit = Credit.new
    @credit.credit_user_id = @user.id
    @credit.credit_amount = @transfer_amount
    @credit.status = 2
    @credit.save
    @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)

    @debit = Debit.new
    @debit.debit_user_id = @transfer_to.id
    @debit.debit_amount = @credit.credit_amount
    @debit.status = 2
    @debit.save

    @utut = UserToUserTrx.new
    @utut.utut_credit_id = @credit.id
    @utut.utut_debit_id = @debit.id
    @utut.status = 2
    @utut.save

    transfer_to_last_balance = @transfer_to.user_last_balance == nil ? 0 : @transfer_to.user_last_balance
    @transfer_to.update(user_last_balance: transfer_to_last_balance + @transfer_amount)
  end 

  def do_stock_trx(trx_type, total_price, amount_share)
    if trx_type == 1
      @credit = Credit.new
      @credit.credit_user_id = @user.id
      @credit.credit_amount = total_price
      @credit.status = 1
      @credit.save
      @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)
      trx_id = @credit.id
      insert_stock_trx(trx_type, amount_share,trx_id)
      p @credit.id
      
      # @st = StockTrx.new 
      # @st.st_stock_id = @stock.id
      # @st.st_trx_id = @credit.id
      # @st.st_type = trx_type
      # @st.st_amount_share = amount_share
      # @st.save
      render json: @st
    end

    if trx_type == 2
      @debit = Debit.new
      @debit.debit_user_id = @user.id
      @debit.debit_amount = total_price
      @debit.status = 1
      @debit.save
      trx_id = @debit.id
      insert_stock_trx(trx_type, amount_share,trx_id)
    end

  end
  
  def insert_stock_trx(trx_type, amount_share,trx_id)
    @st = StockTrx.new 
    @st.st_stock_id = @stock.id
    @st.st_trx_id = trx_id
    @st.st_type = trx_type
    @st.st_amount_share = amount_share
    @st.save
  end

  def get_user_balance
    @balance = @user.get_user_balance
  end
end
