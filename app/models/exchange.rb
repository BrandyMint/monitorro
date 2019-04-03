class Exchange < ApplicationRecord
  include Authority::Abilities

  scope :available, -> { where.not(xml_url: nil) }

  validates :name, presence: true, uniqueness: true

  # TODO Удалять ending slash
  validates :url, presence: true, uniqueness: true, uri_component: { component: :ABS_URI }
  validates :xml_url, uri_component: { component: :ABS_URI }, if: :xml_url
  validates :affiliate_url, uri_component: { component: :ABS_URI }, if: :affiliate_url

  validates :is_available, absence: true, unless: :xml_url

  def self.add_by_url(url)
    uri = URI.parse(url)
    create!(
      name: uri.host,
      url: uri.scheme + '://' + uri.hostname,
      xml_url: url
    )
  end
end
