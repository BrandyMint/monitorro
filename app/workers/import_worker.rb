require 'open-uri'

class ImportWorker
  include Sidekiq::Worker
  include AutoLogger
  include UniqueWorker

  def perform(exchange_id)
    exchange = Exchange.find exchange_id

    data = Nokogiri.parse open(exchange.xml_url)

    data.xpath('//rates/item').each do |item|
      import_rate item
    end
  end

  private

  def import_rate(item)
    ps_from = find_payment_system item.xpath('from').text
    ps_to = find_payment_system item.xpath('to').text
    item.xpath('in').text.to_f
    item.xpath('out').text.to_f
    item.xpath('amount').text.to_f
    item.xpath('minamount').text
    item.xpath('maxamount').text
  end

  def find_payment_system(code)
    PaymentSystem.create_with(name: code).find_or_create_by!(code: code)
  end
end
