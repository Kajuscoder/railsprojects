class CreateFriendlist < ActiveRecord::Migration[7.1]
  def change
    create_table :friendlists do |t|
      t.string :user1
      t.string :user2
      t.integer :state
      t.timestamps
    end
  end
end
