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
    end
  end
end
