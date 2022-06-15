class Exchange < ApplicationRecord
  include Authority::Abilities
  include Archivable

  scope :available, -> { alive.where(is_available: true).where.not(xml_url: nil) }
  scope :with_xml, -> { where.not(xml_url: nil) }

  has_many :affiliate_events

  validates :name, presence: true, uniqueness: true

  before_validation do
    self.url = SimpleIDN.to_ascii url if url.present?
  end
  # TODO Удалять ending slash
  validates :url, presence: true, uniqueness: true, uri_component: { component: :ABS_URI }
  validates :xml_url, uri_component: { component: :ABS_URI }, if: :xml_url
  validates :affiliate_url, uri_component: { component: :ABS_URI }, if: :affiliate_url
  validates :is_available, absence: true, unless: :xml_url

  before_save do
    self.is_available = false if archived?
  end

  def self.add_by_url(url)
    url = SimpleIDN.to_ascii url
    uri = URI.parse(url)
    create!(
      name: uri.host,
      url: uri.scheme + '://' + uri.hostname,
      xml_url: url
    )
  end
end
