Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resource :dapp, only: [:show], controller: 'dapp'
  resource :account, only: [:show, :update], controller: 'account'
  resources :orders, only: [:create, :destroy, :update]
  resources :sell_orders, only: [:create]
  resources :deposits, only: [:create]
  resources :withdrawals, only: [:create]
  resources :token_deposits, only: [:create]
  resources :token_withdrawals, only: [:create]
  
  root to: 'dapp#show'
end
