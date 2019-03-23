class AddIsAvailableToExchangers < ActiveRecord::Migration[5.2]
  def change
    add_column :exchanges, :is_available, :boolean, null: false, default: false
    change_column_null :exchanges, :xml_url, true

    add_index :exchanges, :is_available
  end
end
