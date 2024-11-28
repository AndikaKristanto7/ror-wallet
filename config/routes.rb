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
      end

      scope "/team" do 
        post '/', to: "team#create"
        scope "/unresponded" do 
          get "/deposits", to: "team#get_unresponded_deposits"
          get "/withdraws", to: "team#get_unresponded_withdraws"
        end

        scope "/response" do 
          post "/deposit", to: "team#response_deposit"
          post "/withdraw", to: "team#response_withdraw"
        end

      end 
    end
  end
end
