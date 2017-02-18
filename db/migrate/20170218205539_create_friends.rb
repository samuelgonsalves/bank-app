class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
    	#t.references :user
    	#t.references :friend
      	
      	#t.timestamps
      	t.integer :user_id
      	t.integer :friend_id
    end

    add_index(:friends, [:user_id, :friend_id], :unique => true)
    add_index(:friends, [:friend_id, :user_id], :unique => true)
  end
end
