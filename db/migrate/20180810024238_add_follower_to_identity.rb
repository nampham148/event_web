class AddFollowerToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :follower, :integer
  end
end
