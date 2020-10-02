class AddBuilding < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings do |t|
      t.string "name"
      t.string "description"
      t.boolean "enabled"
    end
  end
end
