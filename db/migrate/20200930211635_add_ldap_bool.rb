class AddLdapBool < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :ldap, :boolean, default: false
  end
  def down
    remove_column :users, :ldap
  end
end
