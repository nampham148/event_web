class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :location
      t.datetime :registration_start
      t.datetime :registration_end
      t.datetime :event_start
      t.datetime :event_end
      t.string :short_desc
      t.text :long_desc
      t.string :picture

      t.timestamps
    end
  end
end
