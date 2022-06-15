class AddLastFindErrorToExchanges < ActiveRecord::Migration[5.2]
  def change
    add_column :exchanges, :last_find_error, :string
  end
end
