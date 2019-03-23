require 'sidekiq/web'
require 'sidekiq-status/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  get '/sidekiq-stats' => proc { [200, { 'Content-Type' => 'text/plain' }, [Sidekiq::Stats.new.to_json]] }
  Sidekiq::Web.set :session_secret, Secrets.secret_key_base
  mount Sidekiq::Web => '/sidekiq'

  root controller: 'dashboard', action: 'index'

  resources :rates, only: [:index]
end
