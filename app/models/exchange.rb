class Exchange < ApplicationRecord
  scope :available, -> { where.not(xml_url: nil) }

  def self.add_by_url(url)
    uri = URI.parse(url)
    create!(
      name: uri.host,
      url: uri.scheme + '://' + uri.hostname,
      xml_url: url
    )
  end
end
