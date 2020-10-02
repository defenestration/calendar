class AddHelpdesks < ActiveRecord::Migration[6.0]
  def change
    create_table :helpdesks do |t|
      t.string "name"
      t.string "url"
      t.boolean "enabled"
    end
  end
end
