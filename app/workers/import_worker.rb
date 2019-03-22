require 'open-uri'

class ImportWorker
  include Sidekiq::Worker
  include AutoLogger
  include UniqueWorker

  def perform(exchange_id)
    exchange = Exchange.find exchange_id

    data = Nokogiri.parse open(exchange.xml_url)

    data.xpath('//rates/item').each do |item|
      puts '---'
      import_rate item
    end
  end

  private

  def import_rate(item)
    item.xpath('from').text
    item.xpath('to').text
    item.xpath('in').text.to_f
    item.xpath('out').text.to_f
    item.xpath('amount').text.to_f
    item.xpath('minamount').text
    item.xpath('maxamount').text
  end
end
