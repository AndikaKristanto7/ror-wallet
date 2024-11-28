class Api::V1::TransactionsController < ApplicationController
  before_action :get_user
  before_action :get_user_balance, only:[:withdraw,:transfer]

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

  private

  def get_user
    @user = User.where(user_acc_number: params[:acc_number],user_pin: Integer(params[:pin])).take
    if @user == nil
      render json: {'code': "error"}, status: :unprocessable_entity
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

  def get_user_balance
    @balance = @user.get_user_balance
  end
end
