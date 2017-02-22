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
		case1 = Friend.where(:friend_id => user1.id, :user_id => user2.id)
		case2 = Friend.where(:friend_id => user2.id, :user_id => user1.id)
		if case1.blank? and case2.blank?
			true
		else
			false
		end 
	end	

end
