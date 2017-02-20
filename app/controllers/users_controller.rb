class UsersController < ApplicationController
  
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
  	@user = User.new(user_params)
  	if @user.save
      log_in user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to welcome
  	else
  		render 'new'
  	end	
  end

  def edit
  	@user = User.find(params[:id])
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
  	@accounts = Account.where(:user_id => params[:id]) #ALL USER ACCOUNTS!!

  	  respond_to do |format|
        format.html 
        format.json { render json: @accounts }
      end 
  end


  def account_create_request

    @user = User.find(params[:id])
   
    account = Account.create(:user_id => @user.id,:balance => 0, :status => 3, :account_id => 100000000)

    if account.save
      flash[:success] = "Your request for a new account is awaiting administrator approval."
    else
      flash[:error] = "Request for a new account failed!"
    end
  end

  #BROKEN!!
  def search_for_users
    @users = User.search(params[:search])
  end

  def show_friends
    @friends = Friend.all
  end

  def new_account
    render 'home'
  end

  private
  
  def user_params
  	params.require(:user).permit(:name, :email,:password,:password_confirmation)
  end



end
