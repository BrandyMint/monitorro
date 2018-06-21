class BestChangeRateRow
  include Virtus.model strict: true

  attribute :exchanger_id,   Integer # ID обменнике по таблице BestExchange bm_exch.dat
  attribute :buy_price,      Float   # BestExchange сумму назвают "отдаете"
  attribute :sell_price,     Float   # BestExchange называют "получите"
  attribute :reserve,        Float   # Резерв
  attribute :time,           Integer

  # Устанавливается при загрузке из репозитория
  attr_accessor :position

  def exchanger_name
    BestChangeChangersRepository.find(exchanger_id).name
  end

  def <=>(other)
    other.rate <=> self.rate
  end

  def rate
    sell_price / buy_price
  end
end
