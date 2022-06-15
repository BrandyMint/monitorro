require 'csv'

CSV.foreach("db/exchangers.csv")  do |row|
  next if row.first == 'Обменник'
  next if row.second.blank?
  url = row.second
  name = row.first
  Exchange.
    create_with(name: name).
    find_or_create_by!(url: url)
  puts url
end
