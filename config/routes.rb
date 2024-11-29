Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do 
      resources :users
      
      scope "/transaction" do 
        post "/deposit", to: "transactions#deposit"
        post "/withdraw", to: "transactions#withdraw"
        post "/transfer", to: "transactions#transfer"
        get "/debits", to: "transactions#get_all_debit_trx"
        get "/credits", to: "transactions#get_all_credit_trx"
        
        scope "/stock" do 
          post "/buy", to: "transactions#buy_stock"
          post "/sell", to: "transactions#sell_stock"
          get "/buy", to: "transactions#get_buy_stock_trx"
          get "/sell", to: "transactions#get_sell_stock_trx"
         end
      end

      scope "/stocks" do 
        get "/", to: "stocks#get_stocks"
        get "/sync", to: "stocks#sync_stocks_to_db"
        get "/find", to: "stocks#find_stock"
      end

      scope "/team" do 
        post '/', to: "team#create"
        scope "/unresponded" do 
          get "/debit", to: "team#get_unresponded_debits"
          get "/credit", to: "team#get_unresponded_credits"
        end

        scope "/response" do 
          post "/debit", to: "team#response_debit_trx"
          post "/credit", to: "team#response_credit_trx"
        end

      end 
    end
  end
end
