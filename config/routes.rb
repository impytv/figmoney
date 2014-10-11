Rails.application.routes.draw do
  devise_for :users
  resources :commits

  resources :transactions

  resources :recurring_transactions

  root 'welcome#index'
end
