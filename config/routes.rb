Rails.application.routes.draw do
  resources :commits

  resources :transactions

  resources :recurring_transactions

  root 'welcome#index'
end
