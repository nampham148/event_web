class CreateChatrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :chatrooms do |t|
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
