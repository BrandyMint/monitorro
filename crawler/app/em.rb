# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# require 'rubygems'
require 'em-http'
require 'nokogiri'

# em-pg-client
require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"

class SteamingDocument < Nokogiri::XML::SAX::Document
  def start_element(name, attrs=[])
    puts "starting: #{name}"
  end

  def end_element(name)
    puts "ending: #{name}"
  end

  def end_document
    puts "should now fire"
  end
end

# puts urls

EM.synchrony do
  concurrency = 16

  result = EM::Synchrony::FiberIterator.new(urls, concurrency).each do |url, iter|
    puts url
    http = EventMachine::HttpRequest.new(url).get
    http.stream { |chunk| puts '11'; io_write << chunk }
    http.callback { puts 'callback'; iter.return(http) }
    http.errback { puts 'errback'; iter.return(http) }
    # io_write.close
  end

  # p results # all completed requests
  EventMachine.stop
end
