class AddDefaultImageToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :image, :text, default: "default-profile-picture.png"
  end
end
