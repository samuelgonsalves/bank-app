module AdminHelper
	def get_all_users_who_are_admins(admins)
		users = []
		admins.each do |admin| 
			users << User.find_by(id: admin.user_id)
		end
		users
	end
end
