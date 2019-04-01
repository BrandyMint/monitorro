class AddIsAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_admin, :boolean, null: false, default: false
    User.update_all is_admin: true
  end
end
