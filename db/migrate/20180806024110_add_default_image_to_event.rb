class AddDefaultImageToEvent < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :picture, :string, default: "default-event-avatar.png"
  end
end
