require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChangeFinder
  class Application < Rails::Application
    require './lib/custom_formatter'
    config.log_formatter = CustomFormatter.new
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    I18n.available_locales = [:ru]
    I18n.default_locale = :ru
    config.time_zone = 'Europe/Moscow'
    Time.zone = 'Europe/Moscow'

    config.autoload_paths += Dir[
      "#{Rails.root}/app/api",
      "#{Rails.root}/app/api/concerns",
      "#{Rails.root}/app/services",
      "#{Rails.root}/app/value_objects",
      "#{Rails.root}/app/builders",
      "#{Rails.root}/app/errors",
      "#{Rails.root}/app/commands",
      "#{Rails.root}/app/validators",
      "#{Rails.root}/app/decorators",
      "#{Rails.root}/app/banks",
      "#{Rails.root}/app/repositories",
      "#{Rails.root}/app/queries",
      "#{Rails.root}/app/workers/concerns",
      "#{Rails.root}/app/workers",
      "#{Rails.root}/app/uploaders"
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
