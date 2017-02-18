class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
    	t.references :user
    	t.references :friend
      	
      	t.timestamps
    end
  end
end
