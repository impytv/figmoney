Rails.application.routes.draw do
  devise_for :users

  resources :transactions

  resources :recurring_transactions

  root 'transactions#index'
end
