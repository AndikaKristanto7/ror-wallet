class Api::V1::CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :update, :destroy]

    def index
      @credits = Credit.all
      render json: @credits
    end

    def show
      render json: @credit
    end

    def create
      @credit = Credit.new(credit_params)

      if @credit.save
        render json: @credit, status: :created
      else
        render json: @credit.errors, status: :unprocessable_entity
      end
    end

    def update
      if @credit.update(credit_params)
        render json: @credit
      else
        render json: @credit.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @credit.destroy
      head :no_content
    end

    private

    def set_credit
      @credit = Credit.find(params[:id])
    end

    def credit_params
      params.require(:credit).permit(:credit_amount, :credit_user_id,:credit_status)
    end  
end
