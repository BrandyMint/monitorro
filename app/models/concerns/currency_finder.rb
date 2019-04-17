module CurrencyFinder
  CURRENCIES = Money::Currency.all.map(&:iso_code).freeze

  def self.setup_currencies
    PaymentSystem.find_each do |ps|
      iso_code = currency_from_ps_code(ps.code)
      puts "#{ps.name} -> #{iso_code}"
      ps.update_column :currency_iso_code, iso_code
    end
  end

  def currency_from_ps_code(code)
    CURRENCIES.find { |cur| code.include? cur }
  end
end
