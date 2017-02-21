class AdminController < ApplicationController

	#page where admin can choose to login/signup
  	def index
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin index page")
	end

	#page after admin logs in
	def home
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin home page")
	end

	#creating admins
	def create
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create admin post_request page")
		@user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
  		if @user.save
			@admin = Admin.create(:predefined => 0, :user_id => @user.id)
      			log_in @user
  			flash[:success] = "Welcome to the Sample App!"
  			redirect_to login_url
  		else
  			render 'create_admin'
  		end
	end


	# manage admins part -------------------------------------------------------------------------------------
	def manage_admins
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage admins page")
	end

	def create_admin
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create admin page")
		@user = User.new
	end

	def view_admins
		@admins = Admin.all
	end

	def delete_admin
		logger.info("(#{self.class.to_s}) (#{action_name}) -- destroying an admin")	   	
		Admin.destroy(params[:id])

	    	respond_to do |format|
	      		format.html { redirect_to view_admins_url() }
	      		format.json { head :no_content }
	    	end
	end

	# manage users part -------------------------------------------------------------------------------------
	def manage_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage users page")
	end

	def view_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view users page")
		@users = User.all
	end

	def destroy_user
		logger.info("(#{self.class.to_s}) (#{action_name}) -- destroying a user")
		admin = Admin.where(user_id: params[:id])	   	
		Admin.destroy(admin[0].id) if !admin.empty?	
		User.destroy(params[:id])

	    	respond_to do |format|
	      		format.html { redirect_to view_users_url() }
	      		format.json { head :no_content }
	    	end
	end
	
	def view_transaction_history
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view transaction history page")	   	
		@user = User.find(params[:id])
	    	@accounts = Account.find_by(user_id: @user.id)
		@transactions = []
		@transfers = []
		@accounts.each do |account|
			@transactions += Transaction.find_by(account_id: account.id)
			@transactions.transfers << Transfer.find_by(transaction_id: account.id)
			@transfers.each do |t|
				@transactions += Transaction.find_by(id: t.transaction_id)	
			end
		end
	end
	
	# manage accounts part -------------------------------------------------------------------------------------
	def manage_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage accounts page")	
	end

	def create_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create accounts(approve request to create) page")	
		# get all the accounts with status pending(3) // active(1) closed(2)
		@accounts = Account.where(status: 3)
	end

	def approve_or_decline_account
		logger.info("(#{self.class.to_s}) (#{action_name}) -- approve_or_decline_account page")		
		@account = Account.find(params[:account_id])
		puts "Admin decision: #{params[:decision]}"
		if params[:decision] == '1'
			@account.status = 1
			@account.save		
		else
			@account.status = 2
			@account.save
		end
		respond_to do |format|
	      		format.html { redirect_to create_accounts_url() }
	      		format.json { head :no_content }
	    	end
	end

	def view_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_accounts page")
		@accounts = Account.all
	end

	def view_account_details
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_account_details page")
		@account = Account.find(params[:id])
		@user = @account.user
	end

	def view_transaction_requests
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_transaction_requests page")
		@transactions = Transaction.where("status = 3") 
	end

	def approve_or_decline_transaction
		logger.info("(#{self.class.to_s}) (#{action_name}) -- approve_or_decline_transaction page")		
		@transaction = Transaction.find(params[:transaction_id])
		if params[:decision] == '1'
			@transaction.status = 1
			@transaction.save		
		else
			@transaction.status = 2
			@transaction.save
		end
		respond_to do |format|
	      		format.html { redirect_to view_transaction_requests_url() }
	      		format.json { head :no_content }
	    	end
	end

	def delete_account
		logger.info("(#{self.class.to_s}) (#{action_name}) -- delete account page")	
		Account.destroy(params[:id])
		respond_to do |format|
	      		format.html { redirect_to view_accounts_url() }
	      		format.json { head :no_content }
	    	end
	end

end
