class AddCurrencyIsoCodeToPaymentSystems < ActiveRecord::Migration[5.2]
  def up
    add_column :payment_systems, :currency_iso_code, :string
  end

  def down
    remove_column :payment_systems, :currency_iso_code
  end
end
