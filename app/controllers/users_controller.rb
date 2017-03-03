class UsersController < ApplicationController
    include UsersHelper

    def index
      if params[:search]
        @users = User.search(params[:search]).order("created_at ASC")
      end
    end

    def new
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Sign Up page")
      @user = User.new
    end
 
    def show
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Fetch User Information")
      @user = User.find(params[:id])

      if is_same_user?(@user,current_user)
        @user
      else
        flash[:error] = "Invalid Operation"
        redirect_to root_url
      end
    end
  
    def create
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Model action to create new user")
      @user = User.find_by_email(params[:email])

      if !@user.nil?
        flash[:success] = "User already exists!"
        redirect_to login_url
      end
  	
      @user = User.new(user_params)
  	  if @user.save
        	  log_in @user
  		  flash[:success] = "Welcome to the Bank App!"
  		  redirect_to login_url
  	  else
  		  render 'new'
  	  end	
    end

    def edit
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Edit User Profile Page")
  	  @user = User.find(params[:id])
      
      if is_same_user?(@user,current_user)
        @user
      else
        flash[:error] = "Invalid Operation"
        redirect_to root_url
      end
    end

    def update
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Model action to update user information")
  	  @user = User.find(params[:id])
  	  if @user.update_attributes(user_params)
		flash[:success] = "Profile updated"
    	  	redirect_to @user

  	  else
  		  render 'edit'
  	  end
    end

    def account
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Account Details Page for current user page")
  	  @user = current_user
      @accounts = Account.where(:user_id => current_user) 

  	  respond_to do |format|
        format.html 
        format.json { render json: @accounts }
      end
    end

    def account_create_request
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Request to create an account for current user")
      @user = User.find(params[:id])
   
      account = Account.create(:user_id => @user.id,:balance => 0, :status => 3)
      if account.save
        flash[:success] = "Your request for a new account is awaiting administrator approval."
      else
        flash[:error] = "Request for a new account failed!"
      end
    end

    def search_for_users
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Search for other users")
      if params[:search]
        @users = User.search(params[:search]).order("created_at DESC")
      end
    end

    def add_friend
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Add a friend for current user")
      f = Friend.new
      user_to_add_as_friend = User.find(params[:id].to_i)

      if are_they_friends(current_user,user_to_add_as_friend)
        flash[:danger] = "You are already friends"
      else
        f.user_id = current_user.id
        f.friend_id = user_to_add_as_friend.id
        if f.save
          flash[:success] = "You are now friends" 
        else
          flash[:error] = "Failed to save in the database"
          #puts f.errors.messages.inspect
        end
      end
      redirect_to search_for_users_url
    end

    def show_friends
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Show firends for the current user page")
      @user = User.find(params[:id])
      
      if is_same_user?(@user,current_user)  
        @friends = Friend.where(:user_id => params[:id])
        @your_friends = []

        @friends.each do |t|
          @your_friends.push( User.find(t.friend_id))
        end

        @friends = Friend.where(:friend_id => params[:id])
        @friends.each do |t|
          @your_friends.push( User.find(t.user_id))
        end

        respond_to do |format|
          format.html 
          format.json { render json: @friends }
        end
      else
        flash[:error] = "Invalid Operation"
        redirect_to root_url
      end
    end

  def transfer_money
    logger.info("(#{self.class.to_s}) (#{action_name}) -- Transfer money to a friend")
    @friend = User.find(params[:id])
    @source_accounts = Account.where(:user_id => current_user,:status => 1)
    @destination_accounts = Account.where(:user_id => @friend.id,:status => 1)
    
    if request.post?
      if !is_number?(params[:amount])
        flash[:danger] = "Incorrect amount format"
        redirect_to account_url
        return
      end


      amount = params[:amount].to_f

      if can_transfer(current_user,@friend,amount)
        source_account = Account.find(params[:source_account_id].to_i)
        destination_account = Account.find(params[:destination_account_id].to_i)
        

        if !source_account.nil? || !destination_account.nil?
          if source_account.balance >= amount
            source_account.balance -= amount
            destination_account.balance += amount
            
            if source_account.save and destination_account.save
              account_id = params[:source_account_id].to_i
              @transaction = create_transaction_model(transfer_type, approved_status, amount, account_id)
              @transaction.save

              destination_account_id = params[:destination_account_id].to_i
              transaction_id = @transaction.id
              @transfer = create_transfer_model(destination_account_id, transaction_id)
              @transfer.save

              flash[:success] = "Transfer Successful"
              UserMailer.transaction_status_mail(@transfer).deliver
              redirect_to account_url
            else
              flash[:danger] = "Failed to save in at least one account"
            end
          else
            flash[:danger] = "Transfer Unsuccessful due to Insufficient funds"
            redirect_to account_url
          end        
        else
          flash[:danger] = "Cannot transfer because either the source or destination account is invalid"
          redirect_to transfer_money_url
        end
      end
    end
  end

    def show_transactions
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Show transactions for current user page")
      @user = User.find(params[:id])
      @accounts = Account.where(:user_id => @user.id)
    end

    def deposit
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Deposit for the current user account")
      @accounts = Account.where(:user_id => current_user, :status => 1)
      
      if request.post?
        @account = Account.find(params[:account_id].to_i)
        
        if !is_number?(params[:amount])
          flash[:danger] = "Incorrect amount format"
          redirect_to account_url
          return
        end

        amount = params[:amount].to_f
        account_id = params[:account_id].to_i
        @Transaction = create_transaction_model(deposit_type, pending_status, amount, account_id)
          
        if @Transaction.save
          flash[:success] = "Transaction initiated, admin approval needed"
          redirect_to account_url
        else
          flash[:danger] = "Deposit Unsuccessful"
          redirect_to account_url
        end
      end
    end

    def withdraw
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Withdraw for the current user account")
      @accounts = Account.where(:user_id => current_user, :status => 1)
      
      if request.post?
        @account = Account.find(params[:account_id].to_i)

        if !is_number?(params[:amount])
          flash[:danger] = "Incorrect amount format"
          redirect_to account_url
          return
        end

        withdraw_amount = params[:amount].to_f

        if is_valid_withdraw(@account, withdraw_amount)
          if withdraw_amount >= 1000.0
            account_id = params[:account_id].to_i
            @Transaction = create_transaction_model(withdraw_type, pending_status, withdraw_amount, account_id)
            
            if @Transaction.save
              flash[:success] = "Transaction initiated. Admin approval needed"
            else
              flash[:error] = "Transaction failed. Retry again"
              redirect_to withdraw_url
            end
          elsif withdraw_amount > 0 && withdraw_amount < 1000.0
            @account.balance -= withdraw_amount
          
            if(@account.save)
              account_id = params[:account_id].to_i
              @Transaction = create_transaction_model(withdraw_type, approved_status, withdraw_amount, account_id)

              if @Transaction.save
                flash[:success] = "Withdrawal successful"
              else
                flash[:danger] = "Withdrawal was Successful, but failed to record transaction"
              end
            end
          end
        else
          flash[:danger] = "Insufficient funds for your withdrawal request/s"
        end

        redirect_to account_url
      end    
    end


    def cancel
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Cancel for the current user transaction")
      @transaction = Transaction.find(params[:id])
      @transaction.status = cancelled_status  # add cancel status for this
      @transaction.save

      redirect_to show_transactions_url(:id => current_user.id)
    end


    def borrow_money
    logger.info("(#{self.class.to_s}) (#{action_name}) -- Borrow money from a friend")
    @friend = User.find(params[:id])
    @destination_accounts = Account.where(:user_id => current_user,:status => 1)
    @source_accounts = Account.where(:user_id => @friend.id,:status => 1)
    
    if request.post?
      amount = params[:amount].to_f

      if can_transfer(current_user, @friend, amount)
        source_account = Account.find(params[:source_account_id].to_i)
        destination_account = Account.find(params[:destination_account_id].to_i)
        
        if !source_account.nil? || !destination_account.nil?        
              account_id = params[:source_account_id].to_i
              @transaction = create_transaction_model(borrow_type, pending_status, amount, account_id)
              @transaction.save

              destination_account_id = params[:destination_account_id].to_i
              transaction_id = @transaction.id
              @transfer = create_transfer_model(destination_account_id, transaction_id)
              @transfer.save

              flash[:success] = "Successfully sent a borrow request!"
              #UserMailer.transaction_status_mail(@transfer).deliver
              redirect_to account_url
        else
          flash[:danger] = "Cannot borrow because either the source or destination account is invalid"
          redirect_to borrow_money_url
        end
      end
    end
  end

  def borrow_requests
	logger.info("(#{self.class.to_s}) (#{action_name}) -- Borrow requets")
	@accounts = current_user.accounts
	@transactions = []
	if !@accounts.nil?
		@accounts.each do |a|
			if !Transaction.where(:account_id => a.id).nil?
				@transactions += Transaction.where(:account_id => a.id)
			end
		end
	end
  end

 
    def new_account
      render 'home'
    end

    private
 	  def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
