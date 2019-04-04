require 'rubygems'
require 'em-http'
require 'nokogiri'
require 'pg/em'
require "em-synchrony"
require "em-synchrony/em-http"


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

# run the EventMachine reactor, this call will block until
# EventMachine.stop is called
EM.run do
  # Nokogiri wants an IO to read from, so create a pipe that it
  # can read from, and we can write to
  io_read, io_write = IO.pipe

	Fiber.new do
		pg.query('select id, xml_url from exchanges where is_available and xml_url is not null') do |result|
			puts Array(result).inspect
			puts '---'
			EM.stop
		end
	end.resume
end

