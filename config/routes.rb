Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :accounts, only: [:index]
  resources :orders, only: [:create] do
    put :fill
    put :cancel
  end
  resources :sell_orders, only: [:create]
  resources :deposits, only: [:create]
  resources :withdrawals, only: [:create]
  resources :token_deposits, only: [:create]
  resources :token_withdrawals, only: [:create]
end
