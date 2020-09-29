class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :admin    
      t.string :password
      t.string :timezone
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
