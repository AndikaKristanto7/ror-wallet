require "latest_stock_price.rb"
class Api::V1::StocksController < ApplicationController
  
  def get_stocks
    @stocks = LatestStockPrice.get_latest_price
    render json: @stocks
  end

  def sync_stocks_to_db
    @stocks = LatestStockPrice.get_latest_price
    @stocks.each do |stock|
      @stock = Stock.where(stock_identifier: stock['identifier']).take
      if @stock == nil
        @stock = Stock.new
        @stock.stock_identifier = stock['identifier']
        @stock.stock_last_price = stock['lastPrice']
        @stock.save
      else
        @stock.update(stock_last_price: stock['lastPrice'],updated_at: DateTime.now)
      end
    end
    
    @stocks = Stock.all
    render json: @stocks 
  end
  
  def find_stock
    @stock = Stock.where(stock_identifier: params['identifier']).take
    if @stock == nil
      render json: {'code':'error','msg':'stock not found'}, status:404
    else
      render json: @stock
    end
  end

end
