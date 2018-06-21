require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/middleware/i18n'
CRONTAB_FILE = './config/crontab.yml'.freeze

if Rails.env.production? || Rails.env.include?('staging') || ENV['SIDEKIQ_ASYNC']
  puts 'SIDEKIQ async mode'
  Sidekiq.options[:poll_interval] = 1

  Sidekiq.configure_server do |config|
    config.redis = Settings.sidekiq_redis.symbolize_keys
    config.error_handlers << proc do |ex, context|
      Bugsnag.notify ex do |b|
        b.meta_data = context
      end
    end
    config.failures_max_count = 50_000
    config.failures_default_mode = :exhausted
    config.server_middleware do |chain|
      chain.add Sidekiq::Status::ServerMiddleware, expiration: 180.minutes
    end
    config.client_middleware do |chain|
      chain.add Sidekiq::Status::ClientMiddleware
    end

  end

  Sidekiq.configure_client do |config|
    config.redis = Settings.sidekiq_redis.symbolize_keys

    config.client_middleware do |chain|
      chain.add Sidekiq::Status::ClientMiddleware
    end
  end

elsif Rails.env.development?
  puts 'SIDEKIQ inline mode'

  require 'sidekiq/testing/inline'
  Sidekiq::Testing.inline!

elsif Rails.env.test?
  require 'sidekiq/testing/inline'
  Sidekiq::Testing.fake!

  Sidekiq.configure_server do |config|
    config.redis = Settings.sidekiq_redis.symbolize_keys
  end
  Sidekiq.configure_client do |config|
    config.redis = Settings.sidekiq_redis.symbolize_keys
  end

else

  raise "Not supported env #{Rails.env}"
end

Sidekiq::Extensions.enable_delay!

Sidekiq::Logging.logger = ActiveSupport::Logger.new Rails.root.join './log/sidekiq.log'
Sidekiq.default_worker_options = { 'backtrace' => true }

if File.exists? CRONTAB_FILE
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(CRONTAB_FILE) unless Rails.env.test? || Rails.env.development?
end
