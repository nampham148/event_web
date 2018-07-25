class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
    add_index :registrations, :user_id
    add_index :registrations, :event_id
    add_index :registrations, [:user_id, :event_id], unique: true
  end
end
