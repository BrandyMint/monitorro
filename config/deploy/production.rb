# frozen_string_literal: true

set :stage, :production

set :rails_env, :production
fetch(:default_env)[:rails_env] = :production

set :disallow_pushing, false

server '95.216.123.243', user: fetch(:user), port: '22', roles: %w[sidekiq web app db bugsnag].freeze
