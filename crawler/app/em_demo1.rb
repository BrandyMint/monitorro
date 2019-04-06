require 'bundler/setup' # Set up gems listed in the Gemfile.
require "em-synchrony"
require "em-synchrony/em-http"
require 'concurrent/map'
require 'concurrent/array'
require 'nokogiri'

require_relative 'exchanges'
require_relative 'document'
require_relative 'saver'

CONNECT_TIMEOUT = 0.3
INACTIVITY_TIMEOUT = 1
CONCURRENCY = 16

exchanges = fetch_exchanges
puts "Total exchanges #{exchanges.count}"
time = Time.now.to_i

universe     = {
  exchanges:    Concurrent::Map.new,
  rates:        Concurrent::Map.new
}

EM.synchrony do
  # iterator will execute async blocks until completion, .each, .inject also work!
  EM::Synchrony::Iterator.new(exchanges, CONCURRENCY).map do |exchange, iter|
    # io_read, io_write = IO.pipe
    exchange_data = universe[:exchanges][exchange['id']] = Hash.new(rates: {}, parse_errors: [], fetch_errors: [])

    parser = Nokogiri::XML::SAX::Parser.new SteamingDocument.new(
      universe_rates: universe[:rates],
      exchange_rates: exchange_data[:rates],
      exchange: exchange,
      parse_errors: exchange_data[:parse_errors],
      time: time
    )
    url = exchange['xml_url']
    # fire async requests, on completion advance the iterator
    http = EventMachine::HttpRequest.
      new(url, connect_timeout: CONNECT_TIMEOUT, inactivity_timeout: INACTIVITY_TIMEOUT).
      aget head: {"accept-encoding" => "gzip, compressed"}
    http.callback { iter.return(http) }
    http.errback { |h| exchange_data[:fetch_error] = { url: url, error: h.error.to_s}; iter.return(http) }
    http.stream { |chunk| parser.parse chunk }
  end
  EventMachine.stop
end

save_universe universe
