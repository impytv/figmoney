Rails.application.routes.draw do
  devise_for :users

  resources :transactions

  resources :transactions_by_month

  resources :recurring_transactions

  root 'transactions#index'
end
