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

  rescue => err
    # TODO Отмечать количество ошибок по обменнику и:
    # 1. Отключать его и переводить на режим "запрос раз в час"
    # 2. Сигнализировать админу и владельцу обменника
    logger.erorr err
  end

  private

  attr_reader :exchange, :payment_system_codes

  def import_rate(item)
    from = item.xpath('from').text
    to = item.xpath('to').text

    # TODO ignore if from and to are empty
    if from.blank? || to.blank?
      logger.error "[#{exchange.id}] Пустые названия платежных систем '#{from}' -> '#{to}'"
      return
    end

    payment_system_codes << from
    payment_system_codes << to

    i = item.xpath('in').text.to_f
    o = item.xpath('out').text.to_f

    data = {
      exchange_id:   exchange.id,
      exchange_name: exchange.name,
      from_ps_code:  from,
      to_ps_code:    to,
      in:            i,
      out:           o,
      amount:        item.xpath('amount').text.to_f,
      minamount:     item.xpath('minamount').text,
      maxamount:     item.xpath('maxamount').text,
      value:         o/i,
      at:            Time.zone.now,
      version:       1
    }

    RatesRepository.add_rate from, to, exchange.id, data
  end
end
