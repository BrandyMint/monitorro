module UniqueWorker
  extend ActiveSupport::Concern
  included do

    # В development отключаем, ниаче не получится перезапустить
    sidekiq_options unique: :until_and_while_executing, unique_across_workers: true, unique_on_all_queues: true unless Rails.env.development?

    sidekiq_retries_exhausted do |msg|
      logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    end
  end
end
