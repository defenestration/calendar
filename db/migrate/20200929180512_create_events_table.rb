class CreateEventsTable < ActiveRecord::Migration[6.0]
  def change
      create_table :events do |t|
        t.timestamps
        t.datetime :dtstart
        t.datetime :dtend
        t.string :flag
        t.string :submitip
        t.string :building
        t.string :hostname
        t.boolean :enterprise
        t.text :description
        t.string :ticketno
        t.string :helpdesk
        t.boolean :downtime
    end
  end
end