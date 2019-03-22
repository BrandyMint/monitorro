Rails.application.routes.draw do
  root controller: 'dashboard', action: 'index'

  resources :rates, only: [:index]
end
