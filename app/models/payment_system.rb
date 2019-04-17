class PaymentSystem < ApplicationRecord

  validates :code, :name, presence: true

  enum status: { pending: 0, allow: 1, ignore: -1 }

  def to_s
    name
  end

  def currency
    return unless currency_iso_code.present?
    Money::Currency.find currency_iso_code
  end
end
