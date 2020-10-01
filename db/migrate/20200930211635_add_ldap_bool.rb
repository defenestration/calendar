class AddLdapBool < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ldap, :boolean
  end
end
