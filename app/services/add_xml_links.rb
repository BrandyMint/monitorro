class AddXmlLinks
  LINKS = ["https://100btc.kiev.ua/request-exportxml.xml",
           "https://100monet.pro/bestchange.xml",
           "https://1exchanger.com/request-exportxml.xml",
           "https://1wm.kz/exportxml.xml",
           "https://1obmen.ru/request-exportxml.xml",
           "https://24-exchange.com/exportxml.xml"]

  def initialize(links: [])
    @links = links
  end

  def perform
    links.map do |link|
      [link, add_link(link)].join(': ')
    end
  end

  private

  attr_reader :links

  def add_link(link)
    uri = URI.parse link
    host = uri.scheme + '://' + uri.host

    exchange = Exchange.find_by_url(host)
    if exchange.present?
      if exchange.xml_url.present?
        if exchange.xml_url == link
          return 'Уже есть такой'
        else
          return "Установка прервана. В базе установленая иная ссылка (#{exchange.xml_url}) для обменника `#{exchange.name}`"
        end
      else
        exchange.update xml_url: link
        return "Установлена для обменника `#{exchange.name}`"
      end
    else
      exchange = Exchange.create!(
        name: uri.host,
        url: host,
        xml_url: link
      )
      return "Создан новый обменник #{exchange.id}"
    end
  rescue => err
    err
  end
end
