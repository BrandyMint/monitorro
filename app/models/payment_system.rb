class PaymentSystem < ApplicationRecord

  validates :code, :name, presence: true

  enum status: { pending: 0, allow: 1, ignore: -1 }

  def to_s
    name
  end

  def currency
    currency_from_ps_code code
  end

  private

  CURRENCIES = %w[RUB USD EUR KZT UAH]
  def currency_from_ps_code(code)
    CURRENCIES.each do |cur|
      return cur if code.include? cur
    end
    code
  end
end
