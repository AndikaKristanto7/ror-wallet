class Api::V1::DebitsController < ApplicationController
  before_action :set_debit, only: [:show, :update, :destroy]

    def index
      @debits = Debit.all
      render json: @debits
    end

    def show
      render json: @debit
    end

    def create
      @debit = Debit.new(debit_params)

      if @debit.save
        render json: @debit, status: :created
      else
        render json: @debit.errors, status: :unprocessable_entity
      end
    end

    def update
      if @debit.update(debit_params)
        render json: @debit
      else
        render json: @debit.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @debit.destroy
      head :no_content
    end

    private

    def set_debit
      @debit = Debit.find(params[:id])
    end

    def debit_params
      params.require(:debit).permit(:debit_amount, :debit_user_id,:debit_status)
    end  
end
