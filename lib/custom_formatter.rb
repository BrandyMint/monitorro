# Source: https://blog.bigbinary.com/2014/03/03/logger-formatting-in-rails.html

class CustomFormatter < Beautiful::Log::Formatter
  include ActiveSupport::TaggedLogging::Formatter

  def message_header(*args)
    "#{super} #{Thread.current[:request_id]} "
  end
end
