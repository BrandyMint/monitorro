# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Exchange.add_by_url('https://e-dengi.org/_export/exchange_xml/')
# Exchange.add_by_url('https://m-obmen.ru/ru/export/xml')
# Exchange.add_by_url('https://obmennik.ws/ru/export/xml')
# Exchange.add_by_url('https://superobmenka.com/ru/export/xml')
# Exchange.add_by_url('https://kassa.cc/valuta.xml')

File.read('./db/payment_systems.txt').each_line do |l|
  code, *name = l.split

  name = name.join ' '

  ps = PaymentSystem.find_by_code(code)

  if ps.present?
    ps.update name: name, status: :allow
  else
    puts "Создаю ПС #{code}"
    PaymentSystem.create!(code: code, name: name, status: :allow)
  end
end

Money::Currency.all.each do |cur|
  PaymentSystem.create_with(name: cur.name).find_or_create_by(code: cur.iso_code)
end
