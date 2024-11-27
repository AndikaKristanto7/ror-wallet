class Api::V1::UsersController < ApplicationController
  before_action :set_users, only: [:show, :update, :destroy]

    def index
      @users = User.all
      render json: @users
    end

    def show
      render json: @user
    end

    def create
      @user = User.new(users_params)
      @user.user_pin = 123456
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(users_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      head :no_content
    end

    def deposit
      @user = User.where(user_acc_number: params[:acc_number]).take
      @pin = @user.user_pin
      if !@user  || @pin != params[:pin]
        render json: @user.errors, status: :unprocessable_entity
      end
      @debit = Debit.new
      @debit.debit_user_id = @user.id
      @debit.debit_amount = params[:deposit_amount]
      @debit.status = 2
      @debit.save
      @user.update(user_last_balance: @user.user_last_balance + @debit.debit_amount)
      render json: @user
    end

    private

    def set_users
      @user = User.find(params[:id])
    end

    def users_params
      params.require(:user).permit(:user_name, :user_acc_number)
    end
end
