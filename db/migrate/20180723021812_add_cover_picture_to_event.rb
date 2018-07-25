class AddCoverPictureToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :cover_picture, :string, default: "default-event-cover.jpg"
  end
end
