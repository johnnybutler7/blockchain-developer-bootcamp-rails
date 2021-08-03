Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :accounts, only: [:index]
  resources :orders, only: [:create] do
    put :fill
  end
end
