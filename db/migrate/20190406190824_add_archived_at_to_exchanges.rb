class AddArchivedAtToExchanges < ActiveRecord::Migration[5.2]
  def change
    add_column :exchanges, :archived_at, :timestamp
  end
end
