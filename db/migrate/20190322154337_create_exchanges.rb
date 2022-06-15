class CreateExchanges < ActiveRecord::Migration[5.2]
  def change
    create_table :exchanges do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :xml_url, null: false

      t.timestamps
    end

    add_index :exchanges, [:name], unique: true
    add_index :exchanges, [:url], unique: true
  end
end
