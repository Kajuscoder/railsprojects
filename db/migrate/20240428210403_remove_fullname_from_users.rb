class RemoveFullnameFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :fullname, :string
  end
end
