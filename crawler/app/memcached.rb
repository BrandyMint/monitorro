require 'dalli'
options = { :namespace => "app_v1", :compress => true }
dc = Dalli::Client.new('localhost:11211', options)

str = ''
2_000_000.times do  |i|
  str << 'a'
end
dc.set('abc', str)
value = dc.get('abc')


puts value.size

