class CreateAffiliateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliate_events do |t|
      t.references :exchange, foreign_key: true, null: false
      t.timestamp :created_at, null: false
    end
  end
end
