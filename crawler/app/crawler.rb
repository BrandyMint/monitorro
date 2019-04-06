require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'nokogiri'

# this is your SAX handler, I'm not very familiar with
# Nokogiri, so I just took an exaple from the RDoc
class SteamingDocument < Nokogiri::XML::SAX::Document
  def start_element(name, attrs=[])
    puts "starting: #{name}"
  end

  def end_element(name)
    puts "ending: #{name}"
  end
end

document = SteamingDocument.new
url = 'http://stackoverflow.com/feeds/question/2833829'

# run the EventMachine reactor, this call will block until
# EventMachine.stop is called
EventMachine.run do
  # Nokogiri wants an IO to read from, so create a pipe that it
  # can read from, and we can write to
  io_read, io_write = IO.pipe

  # run the parser in its own thread so that it can block while
  # reading from the pipe
  EventMachine.defer(proc {
    parser = Nokogiri::XML::SAX::Parser.new(document)
    parser.parse_io(io_read)
  })

  # use em-http to stream the XML document, feeding the pipe with
  # each chunk as it becomes available
  http = EventMachine::HttpRequest.new(url).get
  http.stream { |chunk| io_write << chunk }

  # when the HTTP request is done, stop EventMachine
  http.callback { EventMachine.stop }
end
