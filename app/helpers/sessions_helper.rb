module SessionsHelper
	  # Logs in the given user.
  	def log_in(user)
    	session[:user_id] = user.id
  	end

    # Forgets a persistent session.
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    # Remembers a user in a persistent session.
    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

  	# Returns the user corresponding to the remember token cookie.
    def current_user
      if (user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        admin = Admins.find_by_user_id(user.id)

        if user && user.authenticated?(cookies[:remember_token])
          if admin.nil?
            user.is_admin = false
            user.admin = nil
          else
            user.is_admin = true
            user.admin = admin
          end
          log_in user
          @current_user = user
        end
      end
    end

  	# Returns true if the user is logged in, false otherwise.
  	def logged_in?
    	!current_user.nil? && current_user.db_authenticated?(current_user)
  	end

    # Logs out the current user.
    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
end
