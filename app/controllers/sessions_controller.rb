class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    admin = Admin.find_by_user_id(user.id)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember(user)
      ##### This is the place for first redirect ##########
      if admin.nil?
        user.is_admin = false
        user.admin = nil
        redirect_to root_url
      else
        user.is_admin = true
        user.admin = admin
        redirect_to admin_home_url(id: admin.id)
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
