module AdminHelper
	def session_check
		if !current_user.nil? && current_user.is_admin
			return 
		elsif !current_user.nil? && !current_user.is_admin
			redirect_to root_url
		else
			redirect_to login_url
		end
	end
end
