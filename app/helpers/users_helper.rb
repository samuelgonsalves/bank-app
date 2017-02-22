module UsersHelper
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url,alt: user.name, class:"gravatar")
	end

	def get_id(user)
		user.id
	end

	def is_same_user?(user1,user2)
		return get_id(user1) == get_id(user2)
	end

	def are_they_friends(user1, user2)
		case1 = Friend.where(:user_id => user1.id, :friend_id => user2.friend_id)
	
		if case1.blank? 
			false
		else
			true
		end	
	end

	def is_valid_withdraw(present, request)
		#Get transactions which are active
		transactions = present.transactions.where("transaction_type = #{withdraw_type} and status = #{status_name(3)}")
		
		sum_withdrawals = 0.0
		transactions.each do |t|
			sum_withdrawals += t.amount
		end

		if (present.balance - sum_withdrawals) < request
			return false
		end
			return true
	end
end
