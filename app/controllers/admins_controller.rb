class AdminsController < ApplicationController

	include AdminsHelper

	#page where admin can choose to login/signup
  	def index
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin index page")
		session_check	
	end

	#page after admin logs in
	def home
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the admin home page")
		session_check
	end

	#creating admins
	def create
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create admin post_request page")
		session_check		
		@user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
  		if @user.save
			@admin = Admin.create(:predefined => 0, :user_id => @user.id)
  			redirect_to manage_admins_url
  		else
  			render 'create_admin'
  		end
	end


	# manage admins part -------------------------------------------------------------------------------------
	def manage_admins
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage admins page")
		session_check		
	end

	def create_admin
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create admin page")
		session_check		
		@user = User.new
	end

	def view_admins
		session_check		
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view admins page")
		@admins = Admin.all
	end

	def delete_admin
		logger.info("(#{self.class.to_s}) (#{action_name}) -- destroying an admin")	   	
		session_check		
		admin = Admin.find(params[:id])
		if admin.predefined != 1
			Admin.destroy(params[:id])
		end
		
	    	respond_to do |format|
	      		format.html { redirect_to view_admins_url() }
	      		format.json { head :no_content }
	    	end
	end

	# manage users part -------------------------------------------------------------------------------------
	def manage_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage users page")
		session_check	
	end

	def view_users
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view users page")
		session_check	
		@users = User.all
		@users.each do |user|
			admin = Admin.find_by(:user_id => user.id)
			if admin.nil?
				user.is_admin = false
				user.admin = nil
			else
				user.is_admin = true
				user.admin = admin			
			end
			#puts "ID-------------------#{user.admin}-----------"
		end
		@users
	end

	def destroy_user
		logger.info("(#{self.class.to_s}) (#{action_name}) -- destroying a user")
		session_check
		admin = Admin.where(user_id: params[:id])	   	
		Admin.destroy(admin[0].id) if !admin.empty?	
		user = User.find(params[:id])
		accounts = user.accounts
		if !accounts.nil?
			accounts.each do |each_account|
				
				transactions = each_account.transactions
	
				transactions.each do |each_transaction|
		 			
		 			transfer = Transfer.find_by(:transaction_id => each_transaction.id)
					
					if !transfer.nil?
						Transfer.destroy(transfer.id)
					end
					
					Transaction.destroy(each_transaction)
				end
			
				additional_transfer = Transfer.where(:account_id => each_account.id)
				additional_transfer.each do |each_transfer|
					Transfer.destroy(each_transfer)
				end
			Account.destroy(each_account)
			end
		end
		User.destroy(params[:id])

	    	respond_to do |format|
	      		format.html { redirect_to view_users_url() }
	      		format.json { head :no_content }
	    	end
	end
	
	def view_transaction_history_of_user
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the view transaction history page")	   	
		session_check
		@user = User.find(params[:id])
		@accounts = @user.accounts
	end
	
	# manage accounts part -------------------------------------------------------------------------------------
	def manage_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the manage accounts page")	
		session_check		
	end

	def create_accounts
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the create accounts(approve request to create) page")	
		session_check
		# get all the accounts with status pending(3) // active(1) closed(2)
		@accounts = Account.where(status: 3)
	end

	def approve_or_decline_account
		logger.info("(#{self.class.to_s}) (#{action_name}) -- approve_or_decline_account page")		
		session_check
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
		session_check
		@accounts = Account.all
	end

	def view_account_details
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_account_details page")
		session_check
		@account = Account.find(params[:id])
		@user = @account.user
		if !params[:decision].nil?
			puts "parameter : #{params[:decision]}"
			if !(1...3).include?(params[:decision].to_i)
				puts "need to redirect"
				redirect_to view_account_details_url(@account)
			else
				puts "no need to redirect"
				@account.status = params[:decision]
				@account.save
			end		
		end
	end

	def view_transaction_history
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_transaction history page")
		session_check
		#puts debug(params)
		@account = Account.find(params[:id])
	end

	def view_transaction_requests
		logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering view_transaction_requests page")
		session_check
		@transactions = Transaction.where("status = 3") 
	end

	def approve_or_decline_transaction
		logger.info("(#{self.class.to_s}) (#{action_name}) -- approve_or_decline_transaction page")		
		session_check

		@transaction = Transaction.find(params[:transaction_id])
		if params[:decision] == '1'
			@transaction.status = 1
			@account = Account.find(@transaction.account_id)
			@account.balance -= @transaction.amount
			@account.save			
			@transaction.save		
		else
			@transaction.status = 2
			@transaction.save
		end

		AdminMailer.transanction_status_mail(@transaction).deliver		
		if !params[:url].nil? && params[:url] == 'requests'
			respond_to do |format|
		      		format.html { redirect_to view_transaction_requests_url() }
		      		format.json { head :no_content }
		    	end
		elsif !params[:url].nil? && params[:url] == 'history'
			respond_to do |format|
		      		format.html { redirect_to view_transaction_history_url(params[:account]) }
		      		format.json { head :no_content }
		    	end		
		else
			respond_to do |format|
		      		format.html { redirect_to view_accounts_url() }
		      		format.json { head :no_content }
		    	end
		end
	end

	def delete_account
		logger.info("(#{self.class.to_s}) (#{action_name}) -- delete account page")	
		session_check
		account = Account.find(params[:id])
		account.status = cancelled_status
		account.save
		respond_to do |format|
	      		format.html { redirect_to view_accounts_url() }
	      		format.json { head :no_content }
	    	end
	end

	private
	def admin_params
		params.require(:admin).permit(:transaction_id, :url, :decision)
	end

end
