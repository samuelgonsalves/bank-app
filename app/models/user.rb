class User < ApplicationRecord
	before_save {self.email = email.downcase}
	
	has_many :accounts
	has_and_belongs_to_many :friends,
	class_name: 'User',
	join_table: :friends,
	foreign_key: :user_id,
	association_foreign_key: :friend_id

	validates :name, presence: true, 
						length: {maximum: 50}
	validates :email, presence: true, 
						length: {maximum: 255}, 
						format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, 
						uniqueness: {case_sensitive: false}
	validates :password, presence: true,
						length: {minimum: 6}
	has_secure_password
end
