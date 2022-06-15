class AddAffiliateCredentialsToExchanges < ActiveRecord::Migration[5.2]
  def change
    add_column :exchanges, :affiliate_login, :string
    add_column :exchanges, :affiliate_password, :string
  end
end
