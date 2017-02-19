class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end
 
  def show
  	@user = User.find(params[:id])
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
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

  def account_details
  	@user = User.find(params[:id])
  	@accounts = Account.all
  	respond_to do |format|
      format.html 
      format.json { render json: @accounts }
    end

  end

  private
  
  def user_params
  	params.require(:user).permit(:name, :email,:password,:password_confirmation)
  end



end
