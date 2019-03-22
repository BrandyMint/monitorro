class CreatePaymentSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_systems do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps
    end

    add_index :payment_systems, :name, unique: true
    add_index :payment_systems, :code, unique: true
  end
end
