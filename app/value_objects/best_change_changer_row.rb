class BestChangeChangerRow
  include Virtus.model strict: true

  attribute :id,   Integer # ID обменнике по таблице BestExchange bm_exch.dat
  attribute :name, String  # Имя обменника
end
