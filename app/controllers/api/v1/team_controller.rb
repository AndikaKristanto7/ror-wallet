class Api::V1::TeamController < ApplicationController
  before_action :get_team, except: [:create]
  # before_action :get_user_balance, only:[:withdraw,:transfer]

  def create
    @team = Team.new
    @team.team_u_name = params[:uname]
    @team.team_pass = params[:pass]
    if @team.save
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  def get_unresponded_deposits
    @debit = Debit.where(status: ['1']).order(:id).take(10)
    render json: @debit
  end

  def get_unresponded_withdraws
    @credit = Credit.where(status: ['1']).order(:id).take(10)
    render json: @credit
  end

  def response_deposit
    @debit = Debit.where(id: params[:debit_id],status: ['1']).take
    if @debit == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    else
      @debit.update(status:params[:status],debit_responded_by:@team.id,debit_responded_at:DateTime.current.to_date)
      @user_id = @debit.debit_user_id
      get_user(@user_id)
      get_user_balance()
      @user.update(user_last_balance: @balance)
      render json: @debit     
    end
  end

  def response_withdraw
    @credit = Credit.where(id: params[:credit_id],status: ['1']).take
    if @credit == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    else
      @credit.update(status:params[:status],credit_responded_by:@team.id,credit_responded_at:DateTime.current.to_date)
      @user_id = @credit.credit_user_id
      get_user(@user_id)
      get_user_balance()
      @user.update(user_last_balance: @balance)
      render json: @credit     
    end
  end

  private 
  def get_team
    @team = Team.where(team_u_name: params[:uname],team_pass: params[:pass]).take
    if @team == nil
      render json: {'code': "error"}, status: :unprocessable_entity
    end
  end

  def get_user(user_id)
    @user = User.find(user_id)
  end

  def get_user_balance
    @balance = @user.get_user_balance
  end
end
