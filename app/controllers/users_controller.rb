class UsersController < ApplicationController
  include UsersHelper

  def new
    logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the SignUp page")
  	@user = User.new
  end
 
  def show
    logger.info("(#{self.class.to_s}) (#{action_name}) -- Fetch User from db")
  	@user = User.find(params[:id])
  end
  
  def create
    logger.info("(#{self.class.to_s}) (#{action_name}) -- Model action to create a new user in db")
    #Check if the user already exists in the DB if so redirect to error with message user already exists
    puts params[:email]
    @user = User.find_by_email(params[:email])
    if !@user.nil?
      #User already exists
      flash[:success] = "User already exists!"
      redirect_to login_url
    end
  	
    @user = User.new(user_params)
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to login_url
  	else
  		render 'new'
  	end	
  end

  def edit
  	@user = User.find(params[:id])
    if get_id(@user) != get_id(current_user)
      flash[:error] = "Invalid Operation"
      redirect_to root_url
    else
      @user
    end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile updated"
    	redirect_to @user
  	else
  		render 'edit'
  	end
  end

  def account
  	@user = User.find(params[:id])
  	@accounts = Account.where(user_id: params[:id]) #ALL USER ACCOUNTS!!!
  	respond_to do |format|
      format.html 
      format.json { render json: @accounts }
    end

  end

  def new_account
    render 'home'
  end

  private

 	def user_params
  	params.require(:user).permit(:name, :email,:password,:password_confirmation)
  end
end
