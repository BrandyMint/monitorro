require 'csv'

CSV.foreach("db/exchangers.csv")  do |row|
  name, url, xml_url = row
  Exchange.
    create_with(name: name, xml_url: xml_url, is_available: true).
    find_or_create_by!(url: url)
rescue => err
  puts "#{url} -> #{err}"
end
