# require 'rubygems'
# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'em-http'
require 'nokogiri'

# em-pg-client
# require 'pg/em'
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

pg = PG::EM::Client.new dbname: 'change_finder_development'

urls = []

Fiber.new do
  pg.query('select id, xml_url from exchanges where is_available and xml_url is not null') do |result|
    Array(result).each do |res|
			urls << res['xml_url']
    end
    EM.stop
  end
end.resume

puts urls

exit

EM.synchrony do
# Nokogiri wants an IO to read from, so create a pipe that it
# can read from, and we can write to
io_read, io_write = IO.pipe

# run the parser in its own thread so that it can block while
# reading from the pipe
EventMachine.defer(proc {
	parser = Nokogiri::XML::SAX::Parser.new(document)
	parser.parse_io(io_read)
}, proc { EventMachine.stop })

    concurrency = 16
    urls = ['http://url.1.com', 'http://url2.com']
    results = []

		## when the HTTP request is done, stop EventMachine
    EM::Synchrony::FiberIterator.new(urls, concurrency).each do |url|
			resp = EventMachine::HttpRequest.new(url).get
			resp.stream { |chunk| io_write << chunk }
    end

		io_write.close
    p results # all completed requests
    EventMachine.stop
end
