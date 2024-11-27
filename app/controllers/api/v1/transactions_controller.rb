class Api::V1::TransactionsController < ApplicationController
  before_action :get_user
  before_action :get_user_balance, only:[:withdraw]
  def deposit
    @debit = Debit.new
    @debit.debit_user_id = @user.id
    @debit.debit_amount = params[:deposit_amount]
    @debit.status = 2
    @debit.save
    @user.update(user_last_balance: @user.user_last_balance + @debit.debit_amount)
    render json: @user
  end

  def get_all_debit_trx
    @user_id = @user.id
    @debit = Debit.where(debit_user_id: @user_id).all
    render json: @debit
  end

  def withdraw
    @withdraw_amount = params[:withdraw_amount]
    if((@balance - @withdraw_amount) < 0)
      render json: {'code': "error",'msg': "insufficient wallet balance"}, status: :unprocessable_entity
    else
      @credit = Credit.new
      @credit.credit_user_id = @user.id
      @credit.credit_amount = @withdraw_amount
      @credit.status = 2
      @credit.save
      @user.update(user_last_balance: @user.user_last_balance - @credit.credit_amount)
      render json: @user
    end
  end

  def get_all_credit_trx
    @user_id = @user.id
    @credit = Credit.where(credit_user_id: @user_id).all
    render json: @credit
  end
  
  def transfer
    
  end

  private

  def get_user
    @user = User.where(user_acc_number: params[:acc_number]).take
    if @user == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    else
      @pin = @user.user_pin
      if @pin != Integer(params[:pin])
        render json:{'code': "error"}, status: :unprocessable_entity
      end
    end
  end

  def get_user_balance
    @user_id = @user.id
    @sum_debit = Debit.where(debit_user_id: @user_id,status: ['2']).sum(:debit_amount)
    @sum_credit = Credit.where(credit_user_id: @user_id,status: ['1','2']).sum(:credit_amount)
    @balance = Integer(@sum_debit) - Integer(@sum_credit)
  end 

end
