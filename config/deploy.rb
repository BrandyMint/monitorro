# frozen_string_literal: true

lock '3.11.0'

set :application, 'monitorro.org'
set :user, 'monitorro'

set :repo_url, 'git@github.com:BrandyMint/monitorro.git' if ENV['USE_LOCAL_REPO'].nil?
set :keep_releases, 10

set :linked_files, %w[config/database.yml] #  config/master.key]
set :linked_dirs, %w[log node_modules tmp/pids tmp/cache tmp/sockets public/assets]

set :config_files, fetch(:linked_files)

set :app_version, AppVersion.format('%M.%m.%p')

set :sidekiq_processes, 1
set :sidekiq_options_per_process, ['--queue critical --queue default']

set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

ask :branch, ENV['BRANCH'] || proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :assets_dependencies, %w[app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb config/initializers/assets.rb]

set :local_assets_dir, 'public'

set :puma_init_active_record, true

set :db_local_clean, false
set :db_remote_clean, true

set :bugsnag_api_key, Settings.bugsnag_api_key
set :app_version, AppVersion.to_s
