Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resource :session, only: [:create]
    namespace :user do
      resource :wallet, only: [:show, :destroy] do
        member do
          post :deposit
          post :withdraw
          post :transfer
        end
        scope module: :wallet do
          resources :accounts, param: :currency_id, only: [:index, :create, :show, :destroy] do
            member do
              get :transactions
            end
          end
        end
        resources :transactions, only: [:index, :show, :destroy]
      end
    end
  end

end
