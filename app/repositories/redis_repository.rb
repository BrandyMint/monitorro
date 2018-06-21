require 'oj'

class RedisRepository
  include Singleton

  class << self
    delegate :find, :get, :set, :keys, :getRows, :setRows, to: :instance
  end

  delegate :keys, to: :store

  def initialize(ns = nil)
    @ns = ns
  end

  def find(id)
    get(id) || "Not found #{id}"
  end

  def getRows(key)
    value = get key
    return [] unless value.present?
    value.each_with_index { |row, index| row.position = index }
  end

  def setRows(key, data)
    set key, data
  end

  def get(id)
    Oj.load store.get id
  end

  def set(id, data)
    store.set id, Oj.dump(data)
  end

  private

  def store
    @store ||= Redis::Namespace.new(
      @ns ||= self.class.to_s.underscore,
      redis: Redis.new(Settings.best_change_repository.redis.symbolize_keys)
    )
  end
end
