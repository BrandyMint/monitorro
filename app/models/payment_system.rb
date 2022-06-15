class PaymentSystem < ApplicationRecord

  validates :code, :name, presence: true, uniqueness: true

  enum status: { pending: 0, allow: 1, ignore: -1 }

  def to_s
    name
  end

  def currency
    return unless currency_iso_code.present?
    Money::Currency.find currency_iso_code
  end

  def currency=(value)
    if value.present?
      self.currency_iso_code = Money::Currency.find(value).iso_code
    else
      self.currency_iso_code = nil
    end
  end
end
