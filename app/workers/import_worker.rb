require 'open-uri'

class ImportWorker
  include Sidekiq::Worker
  include AutoLogger

  TIMEOUT = 2

  def perform(exchange_id)
    @exchange = Exchange.find exchange_id
    @payment_system_codes = Set.new
    logger.info "Load #{exchange_id} (#{exchange.name})"
    data = Nokogiri.parse open(exchange.xml_url, read_timeout: TIMEOUT)
    data.xpath('//rates/item').each do |item|
      import_rate item
    end

    payment_system_codes.each do |code|
      PaymentSystem.create_with(name: code).find_or_create_by!(code: code)
    end
  end

  private

  attr_reader :exchange, :payment_system_codes

  def import_rate(item)
    from = item.xpath('from').text
    to = item.xpath('to').text
    logger.info "-- parse item #{from}->#{to}"

    payment_system_codes << from
    payment_system_codes << to

    data = {
      exchange:    exchange.name,
      exchange_id: exchange.id,
      in:          item.xpath('in').text.to_f,
      out:         item.xpath('out').text.to_f,
      amount:      item.xpath('amount').text.to_f,
      minamount:   item.xpath('minamount').text,
      maxamount:   item.xpath('maxamount').text
    }

    RatesRepository.add_rate from, to, exchange, data
  end
end
