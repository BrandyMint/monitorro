require 'pg/em'

def fetch_exchanges
  exchanges = []
  pg = PG::EM::Client.new dbname: 'change_finder_development'

  EM.run do
    Fiber.new do
      pg.query('select id, xml_url from exchanges where xml_url is not null') do |result|
        Array(result).each do |res|
          exchanges << res
        end
        EM.stop
      end
    end.resume
  end
  exchanges
end
