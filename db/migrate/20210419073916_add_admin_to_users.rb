class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :admin, :boolean, default: false
    User.update_all(admin: false)
  end

  def down
    remove_column :users, :admin
  end
end
