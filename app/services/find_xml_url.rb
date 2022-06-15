# Провряет наличие XML-фида у обменика и если есть,
# то сохраняет его
#
# Пример:
#
# > FindXmlUrl.find_all

class FindXmlUrl
  include AutoLogger

  TIMEOUT = 2

  PATHS = [
     '/_export/exchange_xml/',
     "/ru/export/xml",
     "/export/xml",
     '/valuta.xml',
     '/request-exportxml.xml',
     '/exportxml.xml',
     '/rates.xml',
     '/bestchange.xml'
  ]

  def self.find_all
    Exchange.where(xml_url: nil).find_each do |e|
      new(e).find!
    end
  end

  def initialize(exchange)
    @exchange = exchange
  end

  def find!
    return if exchange.xml_url.present?
    PATHS.each do |path|
      xml_url = exchange.url + path
      logger.debug "Try #{xml_url}"
      if is_xml? xml_url
        logger.info "Find #{path} for #{exchange.url}"
        exchange.update xml_url: xml_url
        break
      end
    end
  end

  private

  attr_reader :exchange

  def is_xml?(url)
    content = open url, read_timeout: TIMEOUT
    data = Nokogiri.parse content
    data.xpath('//rates/item').any?
  # rescue OpenURI::HTTPError, Net::OpenTimeout, Net::ReadTimeout, OpenSSL::SSL::SSLError, URI::InvalidURIError => err
  rescue StandardError => err
    exchange.update last_find_error: err.message
    logger.debug "#{url} -> #{err}"
    false
  end
end
