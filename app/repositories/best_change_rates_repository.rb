# Класс нужно предварительно загрузить, чтобы Oj его использовал
require 'best_change_rate_row'

# Репозиторий bestchange-евских рейтингов
#
class BestChangeRatesRepository < RedisRepository
  KEY_SEPARATOR = '-'.freeze

  class << self
    # Идентификаторы платежных систем в bestchange
    def build_direcition_key(id1, id2)
      [id1, id2].join KEY_SEPARATOR
    end
  end

  # key - ключ вида ID1_ID2
  # где ID1, ID2 - идентификаторы направления обмена из BestExchange (PaymentSystem#id_b)
  # возвращает список BestChangeRow
end
