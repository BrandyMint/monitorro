class RatesRepository
  include Singleton

  # Seconds to alive rate
  TIMEOUT = 300
  SEP = ':'.freeze

  class << self
    delegate :get_rates_count, :add_rate, :list_rates, :get_rates_count_for_exchange, :list_rates_for_exchange, to: :instance
  end

  def get_rates_count(from_ps_code, to_ps_code = '*')
    key = [from_ps_code, to_ps_code, '*'].join SEP
    redis.keys(key).count
  end

  def add_rate(from_ps_code, to_ps_code, exchange_id, data)
    rate = get_rate(from_ps_code, to_ps_code, exchange_id)

    data = data.merge ex_value: rate.value if rate.present?
    set_rate from_ps_code, to_ps_code, exchange_id, data
  end

  def get_rate(from_ps_code, to_ps_code, exchange_id)
    key = [from_ps_code, to_ps_code, exchange_id].join SEP
    value = redis.get key
    OpenStruct.new Oj.load(value) if value.present?
  end

  def set_rate(from_ps_code, to_ps_code, exchange_id, data)
    key = [from_ps_code, to_ps_code, exchange_id].join SEP
    redis.setex(
      key,
      TIMEOUT,
      Oj.dump(data)
    )
  end

  def list_rates(from_ps_code, to_ps_code)
    key = [from_ps_code, to_ps_code, '*'].join SEP
    redis.keys(key).map do |key|
      value = redis.get(key)
      OpenStruct.new Oj.load(value) if value.present?
    end.compact.sort do |a,b|
      b.value <=> a.value
    end
  end

  def list_rates_for_exchange(exchange_id)
    key = ['*', exchange_id].join SEP
    redis.keys(key).map do |key|
      value = redis.get(key)
      OpenStruct.new Oj.load(value) if value.present?
    end.compact
  end

  def get_rates_count_for_exchange(exchange_id)
    key = ['*', exchange_id].join SEP
    redis.keys(key).count
  end

  private

  def redis
    $redis ||= Redis.new Settings.redis.symbolize_keys
  end
end
