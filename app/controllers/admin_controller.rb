class AdminController < ApplicationController
	
	include AdminHelper

	#page where admin can choose to login/signup
  	def index
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin index page")
		@admin = Admin.find(1)
	end

	#page after admin logs in
	def home
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin home page")
		@admin = Admin.find(params[:id])
	end

	# manage admins part -------------------------------------------------------------------------------------
	def manage_admins
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage admins page")
		@admin = Admin.find(1)
	end

	def create_admin
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create admin page")
	end

	def view_admins
		admins = Admin.all
		@users = get_all_users_who_are_admins(admins)
	end

	# manage users part -------------------------------------------------------------------------------------
	def manage_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage users page")
		@admin = Admin.find(1)
	end

	def view_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view users page")
		@users = User.all
	end

	def destroy_user
		logger.info("(#{self.class.to_s}) (#{action_name}) -- destroying a user")	   	
		@user = User.find(params[:id])
	    	@user.destroy

	    	respond_to do |format|
	      		format.html { redirect_to admins_url }
	      		format.json { head :no_content }
	    	end
	end
	
	def view_transaction_history
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view transaction history page")	   	
		#@user = User.find(params[:id])
	    	@user = User.find(1)
		@accounts = Account.find_by(user_id: @user.id)
		@transactions = Array.new
		@transfers = Array.new
		@accounts.each do |account|
			@transactions += Transaction.find_by(account_id: account.id)
			@transfers += Transfer.find_by(account_id: account.id)
			@transfers.each do |t|
				@transactions += Transaction.find_by(id: t.transaction_id)	
			end
		end
	end
	
	# manage accounts part -------------------------------------------------------------------------------------
	def manage_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage accounts page")
		@admin = Admin.find(1)	
	end

	def create_account
		# get all the accounts with status pending(3) // active(1) closed(3)
		@accounts = Account.find_by(status: 3)
	end

	def view_accounts
		@accounts = Account.all
	end

	def view_account_details
		@account = Account.find(params[:id])
	end

	def view_transaction_requests
		@transactions = Transaction.where("type = 1 OR type = 2 AND status = 3") 
	end

end
