require 'benchmark'
require 'dalli'
require 'msgpack'

DALLI_OPTIONS = { :namespace => "monitorro", :compress => true }

# value = dc.get('abc')

def save_universe(universe)
  puts 'before save'
  puts universe[:exchanges].size
  puts universe[:rates].values.map(&:size).sum

  dc = Dalli::Client.new('localhost:11211', DALLI_OPTIONS)
  Benchmark.bmbm do |r|
    r.report('Serialize') do
      universe.each_pair do |key, value|
        if value.is_a? Concurrent::Map
          hash = {}
          value.each_pair { |k, v| hash[k] = v }
        else
          hash = value
        end
        serialized = MessagePack.pack hash
        dc.set key, serialized
      end
    end

    puts
    puts 'after read'

    r.report 'Read' do
      u = {}
      %i(exchanges rates).each do |key|
        u[key] = MessagePack.unpack dc.get key
      end
      puts u[:exchanges].size
      puts u[:rates].values.map(&:size).sum
    end
  end
end
