class AddAffiliateUrlToExchanges < ActiveRecord::Migration[5.2]
  def change
    add_column :exchanges, :affiliate_url, :string
  end
end
