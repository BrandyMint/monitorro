source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.expand_path('../.ruby-version', __FILE__)).chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'nokogiri'
gem 'draper', '~> 3.0.1' # , github: 'drapergem/draper'
gem 'non-stupid-digest-assets'
# Use Redis adapter to run Action Cable in production
gem "hiredis", "~> 0.6.0"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0", :require => ["redis", "redis/connection/hiredis"]
gem 'redis-namespace'
gem 'redis-rails'
gem 'dalli'

gem 'oj' # optimized json

gem 'money'
gem 'money-rails'

gem 'slim'
gem 'slim-rails'
gem 'nanoid'

gem 'virtus'

gem 'auto_logger', '~> 0.1.4'
gem 'unique_worker', github: 'BrandyMint/unique_worker'
gem 'noty_flash', github: 'BrandyMint/noty_flash'
gem 'nprogress-rails'

gem 'ruby-progressbar'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'momentjs-rails', '>= 2.9.0'
gem 'ionicons-rails'

gem 'settingslogic'

gem 'sidekiq-reset_statistics'
gem 'sidekiq-failures', github: 'mhfs/sidekiq-failures'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-status'
gem 'sidekiq'
gem 'rufus-scheduler', '~> 3.4.0'
gem 'sidekiq-cron'

gem 'beautiful-log'
gem 'foreman'

gem 'rcsv' # Rcsv is a fast CSV parsing library for MRI Ruby
gem 'rubyzip', '>= 1.0.0' # will load new rubyzip version
# In Gem hell migrating to RubyZip v1.0.0? Include zip-zip in your Gemfile and everything's coming up roses!
# для axlsx
gem 'zip-zip'


gem 'semver2'
gem 'active_link_to'
gem 'simple-navigation', '~> 3.13.0' # git: 'git://github.com/andi/simple-navigation.git'
gem 'simple-navigation-bootstrap'
gem 'bugsnag'
gem 'bootstrap-sass', '~> 3.4'
gem 'breadcrumbs_on_rails'
gem 'phone', github: 'BrandyMint/phone', branch: 'feature/russia'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'pry'
  gem 'bond'
  gem 'pry-rails'
  gem 'pry-byebug'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'guard'
  gem 'terminal-notifier-guard' # , '~> 1.6.1', require: darwin_only('terminal-notifier-guard')

  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  gem 'guard-rails'
  gem 'guard-rubocop'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-git-with-submodules', '~> 2.0'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma', require: false

  # run bundle exec cap production master_key:setup
  # first time
  gem 'capistrano-master-key', github: 'virgoproz/capistrano-master-key', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
