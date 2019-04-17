class AddCurrencyIsoCodeToPaymentSystems < ActiveRecord::Migration[5.2]
  include CurrencyFinder

  def up
    add_column :payment_systems, :currency_iso_code, :string
    PaymentSystem.find_each do |ps|
      iso_code = currency_from_ps_code(ps.code)
      puts "#{ps.name} -> #{iso_code}"
      ps.update_column :currency_iso_code, iso_code
    end
  end

  def down
    remove_column :payment_systems, :currency_iso_code
  end
end
