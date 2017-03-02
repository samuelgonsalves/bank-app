class UsersController < ApplicationController
    include UsersHelper

    def index
      if params[:search]
        @users = User.search(params[:search]).order("created_at ASC")
      end
    end

    def new
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Entering the SignUp page")
      @user = User.new
    end
 
    def show
      logger.info("(#{self.class.to_s}) (#{action_name}) -- Fetch User from db")
      @user = User.find(params[:id])	
      if is_same_user?(@user,current_user)
        @user
      else
        flash[:error] = "Invalid Operation"
        redirect_to root_url
      end
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
  		  flash[:success] = "Welcome to the Bank App!"
  		  redirect_to login_url
  	  else
  		  render 'new'
  	  end	
    end

    def edit
  	  @user = User.find(params[:id])
      if is_same_user?(@user,current_user)
        @user
      else
        flash[:error] = "Invalid Operation"
        redirect_to root_url
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
  	  @user = current_user
      @accounts = Account.where(:user_id => current_user) 

  	  respond_to do |format|
        format.html 
        format.json { render json: @accounts }
      end
    end

    def account_create_request
      @user = User.find(params[:id])
   
      account = Account.create(:user_id => @user.id,:balance => 0, :status => 3)
      if account.save
        flash[:success] = "Your request for a new account is awaiting administrator approval."
      else
        flash[:error] = "Request for a new account failed!"
      end
    end

    def search_for_users
      if params[:search]
        @users = User.search(params[:search]).order("created_at DESC")
      end
    end

    def add_friend   
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
          puts f.errors.messages.inspect
        end
      end
      redirect_to search_for_users_url
    end

    def show_friends
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
    @friend = User.find(params[:id])
    @source_accounts = Account.where(:user_id => current_user,:status => 1)
    @destination_accounts = Account.where(:user_id => @friend.id,:status => 1)
    if request.post?
      amount = params[:amount].to_f

        if can_transfer(current_user,@friend,amount)
          source_account = Account.find(params[:source_account_id].to_i)
          destination_account = Account.find(params[:destination_account_id].to_i)
        

          if !source_account.nil? || !destination_account.nil?
            if source_account.balance > amount
              source_account.balance -= amount
              destination_account.balance += amount
              if source_account.save and destination_account.save
                @transaction = Transaction.new
                @transaction.transaction_type = transfer_type
                @transaction.status = approved_status
                @transaction.start = Time.now
                @transaction.finish = Time.now
                @transaction.amount = params[:amount].to_f
                @transaction.account_id = params[:source_account_id].to_i
                @transaction.save

                @transfer = Transfer.new
                @transfer.account_id = params[:destination_account_id].to_i
                @transfer.transaction_id = @transaction.id
                @transfer.save

                
                flash[:success] = "Transfer Successful"
                redirect_to account_url
              else
                flash[:error] = "Failed to save in at least one account"
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
      @user = User.find(params[:id])
      @accounts = Account.where(:user_id => @user.id)
    end

    def deposit
      @accounts = Account.where(:user_id => current_user, :status => 1)
      if request.post?
        @account = Account.find(params[:account_id].to_i)
        @account.balance += params[:amount].to_f

        if @account.save
          @Transaction = Transaction.new
          @Transaction.transaction_type = deposit_type
          @Transaction.status = approved_status
          @Transaction.start = Time.now
          @Transaction.finish = Time.now
          @Transaction.amount = params[:amount].to_f
          @Transaction.account_id = params[:account_id].to_i

          if @Transaction.save
            flash[:success] = "Deposit was Successful"
            redirect_to account_url
          else
            flash[:danger] = "Deposit was Successful, but failed to record transaction"
            redirect_to account_url
          end
        else
          flash[:error] = "Deposit was Unsuccessful"
          redirect_to root_url
        end
      end
    end

    def withdraw
      @accounts = Account.where(:user_id => current_user, :status => 1)
      if request.post?
        @account = Account.find(params[:account_id].to_i)
        withdraw_amount = params[:amount].to_f

        if is_valid_withdraw(@account, withdraw_amount)
          if withdraw_amount >= 1000.0
            @Transaction = Transaction.new
            @Transaction.transaction_type = withdraw_type
            @Transaction.status = pending_status
            @Transaction.start = Time.now
            @Transaction.finish = Time.now
            @Transaction.amount = withdraw_amount
            @Transaction.account_id = params[:account_id].to_i

            if @Transaction.save
              flash[:success] = "Transaction initiated. Admin approval needed"
            else
              flash[:error] = "Transaction failed. Retry again"
              redirect_to withdraw_url
            end
          elsif withdraw_amount > 0 && withdraw_amount < 1000.0
            @account.balance -= withdraw_amount
          
            if(@account.save)
              @Transaction = Transaction.new
              @Transaction.transaction_type = withdraw_type
              @Transaction.status = approved_status
              @Transaction.start = Time.now
              @Transaction.finish = Time.now
              @Transaction.amount = withdraw_amount
              @Transaction.account_id = params[:account_id].to_i

              if @Transaction.save
                flash[:success] = "Withdrawal successful"
              else
                flash[:danger] = "Withdrawal was Successful, but failed to record transaction"
              end
            end
          end
        end
        redirect_to account_url
      end    
    end


    def cancel
      puts "Test #{params[:id]}"
      @transaction = Transaction.find(params[:id])
      @transaction.status = 4  # add cancel status for this
      @transaction.save
      redirect_to show_transactions_url(:id => current_user.id)
    end


    def new_account
      render 'home'
    end

    private

 	  def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
