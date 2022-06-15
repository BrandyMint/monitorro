class AffiliateEvent < ApplicationRecord
  scope :by_month, -> (month) { where year: month.split('-').first, month: month.split('-').second }

  belongs_to :exchange

  before_create do
    self.created_at = Time.zone.now
    self.date = created_at.to_date
    self.year = date.year
    self.month = date.month
    self.day = date.day
  end
end
