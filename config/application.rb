require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Monitorro
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

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

    config.hosts << ENV.fetch('MONITORRO_HOST', 'localhost')
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
