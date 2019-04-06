
class SteamingDocument < Nokogiri::XML::SAX::Document
  SEP = ':'

  PARAMS = %w(from to in out minamount maxamount amount param)
  #<item>
  #  <from>PMUSD</from>
  #  <to>YAMRUB</to>
  #  <in>1</in>
  #  <out>58.537374661200005</out>
  #  <minamount>3 USD</minamount>
  #  <maxamount>5892.15 USD</maxamount>
  #  <amount>344910.5</amount>
  #  <param>manual</param>
  #</item>

  def initialize(universe_rates: , exchange_rates: , exchange: , parse_errors:, time: )
    @time = time

    @exchange_rates = exchange_rates
    @universe_rates = universe_rates
    @exchange = exchange
    @xml_url = exchange['xml_url']
    @item = nil
    @path = []
    @parse_errors = []
    super()
  end

  def start_element(name, attrs=[])
    @path << name
    @item = {} if name == 'item'
  end

  def characters(str)
    @str = str
  end

  def end_element(name)
    if @path.last == name
      @path.pop
    else
      raise "ETF? #{path} -? #{name}"
    end
    if name == 'item'
      add_rate @item
      @item = nil
    elsif PARAMS.include? name
      @item[name] = @str
      @str = nil
    end
  rescue => err
    @parse_errors << "#{err} #{@path}"
  end

  def error(string)
    @parse_errors << string
  end

  def end_document
  end

  private

  def add_rate(item)
    # TODO ignore not allowed payment systems
    item['at'] = @time
    rate_key = [item['from'], item['to']].join SEP

    @exchange_rates[rate_key] = item

    # TODO sort
    @universe_rates.put_if_absent rate_key, Concurrent::Array.new
    @universe_rates[rate_key] << item.merge(exchange_id: @exchange['id'])
  end

  def current
    @path.last
  end
end
