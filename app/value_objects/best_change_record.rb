class BestChangeRecord
  include Virtus.model strict: true
  NULL_STUB = 9999

  attribute :exchanger_id,      Integer # ID обменнике по таблице BestExchange bm_exch.dat
  attribute :exchanger_name,    String  # Имя обменника
  attribute :buy_price,         Float   # BestExchange сумму назвают "отдаете"
  attribute :sell_price,        Float   # BestExchange называют "получите"
  attribute :reserve,           Float   # Резерв
  attribute :time,              Integer
  attribute :position,          Integer
  attribute :base_rate_percent, Float
  # Может быть nil, если у нас отсутвует котировка на этом направлении
  attribute :target_rate_percent # Nil or Float
  attribute :status #,            BestChangeStatus

  def is_my?
    exchanger_id == Settings.best_change_repository.exchanger_id
  end

  def id
    exchanger_id
  end

  def <=>(other)
    (self.target_rate_percent || NULL_STUB) <=> (other.target_rate_percent || NULL_STUB)
  end

  def rate
    sell_price / buy_price
  end
end
