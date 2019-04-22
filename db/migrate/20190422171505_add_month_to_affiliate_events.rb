class AddMonthToAffiliateEvents < ActiveRecord::Migration[5.2]
  def change
    AffiliateEvent.delete_all
    add_column :affiliate_events, :date, :date, null: false
    add_column :affiliate_events, :month, :integer, null: false
    add_column :affiliate_events, :year, :integer, null: false
    add_column :affiliate_events, :day, :integer, null: false

    add_index :affiliate_events, [:year, :month, :day, :exchange_id], name: :full
  end
end
