require 'sidekiq/web'
require 'sidekiq-status/web'
require 'sidekiq/cron/web'
require 'route_constraints'

Rails.application.routes.draw do
  concern :archivable do
    member do
      delete :archive
      post :restore
    end
  end
  # default_url_options Settings.default_url_options.symbolize_keys
  get '/sidekiq-stats' => proc { [200, { 'Content-Type' => 'text/plain' }, [Sidekiq::Stats.new.to_json]] }
  Sidekiq::Web.set :session_secret, Secrets.secret_key_base
  mount Sidekiq::Web => '/sidekiq', constraints: RouteConstraints::AdminRequiredConstraint.new

  root controller: 'dashboard', action: 'index'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
  end
  resource :user, only: [:edit, :update], controller: :user

  resources :rates, only: [:index]
  resources :exchanges, only: [:index, :show] do
    concerns :archivable
    member do
      get :go
    end
  end
  scope '/admin', module: :admin, as: :admin do
    root :to => redirect('/admin/exchanges')
    resources :exchanges
    resources :currencies, only: [:index]
    resources :payment_systems do
      member do
        put :ignore
        put :allow
      end
    end
    resources :users, only: [:index]
    resources :exchange_links, only: [:new, :create]
  end
end
