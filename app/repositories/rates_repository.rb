class RatesRepository
  include Singleton

  # Seconds to alive rate
  TIMEOUT = 300

  class << self
    delegate :get_rates_count, :add_rate, :list_rates, to: :instance
  end

  def get_rates_count(from_ps_code, to_ps_code)
    key = [from_ps_code, to_ps_code, '*'].join(':')
    redis.keys(key).count
  end

  def add_rate(from_ps_code, to_ps_code, exchange, data)
    key = [from_ps_code, to_ps_code, exchange.id].join(':')
    redis.setex(
      key,
      TIMEOUT,
      Oj.dump(data)
    )
  end

  def list_rates(from_ps_code, to_ps_code)
    key = [from_ps_code, to_ps_code, '*'].join(':')
    redis.keys(key).map do |key|
      value = redis.get(key)
      OpenStruct.new Oj.load(value) if value.present?
    end.compact.sort do |a,b|
      b.out <=> a.out
    end
  end

  private

  def redis
    $redis ||= Redis.new Settings.redis.symbolize_keys
  end
end
