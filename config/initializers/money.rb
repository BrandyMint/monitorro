# Money.locale_backend = :i18n

MoneyRails.configure do |config|
  # config.default_bank = Money::Bank::VariableExchange.new(Gera::CurrencyExchange)
  config.amount_column = { postfix: '_cents', type: :integer, null: false, limit: 8, default: 0, present: true }

  # default
  config.rounding_mode = BigDecimal::ROUND_HALF_EVEN
  config.default_format = {
    no_cents_if_whole: true,
    translate: true,
    drop_trailing_zeros: true
  }
end

Money::Currency.all.each do |cur|
  Money::Currency.unregister cur.id.to_s
end

Psych.load( File.read "#{Rails.root}/config/currencies.yml" ).
  each { |key, cur| Money::Currency.register cur.symbolize_keys }

priority = Money::Currency.all.count + 1
File.read('./config/currencies.txt').each_line do |l|
  code, *name = l.split
  name = name.join ' '

  unless Money::Currency.find(code)
    Money::Currency.register iso_code: code, name: name, priority: priority+=1
  end
end
