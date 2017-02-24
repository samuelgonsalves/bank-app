class User < ApplicationRecord
	attr_accessor :remember_token
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

	has_secure_password
	validates :password, presence: true,
						length: {minimum: 6}

  #Search feature
  def self.search(search)
      puts "Search: #{search}"
      where("name ilike ? or email ilike ?", "%#{search}%", "%#{search}%")
  end

  attr_accessor :is_admin, :admin

	# Returns the hash digest of the given string.
  	def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
  	end

  	# Returns a random token.
  	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	# Remembers a user in the database for use in persistent sessions.
  	def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
  	end

  	# Returns true if the given token matches the digest.
  	def authenticated?(remember_token)
  		return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
  	end

    def db_authenticated?(current_user)
      if current_user.remember_digest.nil?
        return false 
      else
        return true
      end
    end

  	# Forgets a user.
  	def forget
    	update_attribute(:remember_digest, nil)
  	end
end
