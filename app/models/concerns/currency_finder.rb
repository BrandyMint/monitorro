module CurrencyFinder
  CURRENCIES = Money::Currency.all.map(&:iso_code).freeze

  def currency_from_ps_code(code)
    CURRENCIES.find { |cur| code.include? cur }
  end
end
