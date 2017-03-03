module UsersHelper
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url,alt: user.name, class:"gravatar")
	end

	def get_id(user)
		user.id
	end

	def is_same_user?(user1,user2)
		return get_id(user1) == get_id(user2)
	end

	def are_they_friends(current_user, user_to_add_as_friend)
		case1 = Friend.where(:user_id => current_user.id, :friend_id => user_to_add_as_friend.id)
		case2 = Friend.where(:user_id => user_to_add_as_friend.id, :friend_id => current_user.id)
		
		if case1.blank? && case2.blank?
			false
		else
			true
		end	
	end

	def is_valid_withdraw(present, request)
		#Get transactions which are active
		transactions = present.transactions.where("transaction_type = #{withdraw_type} and status = #{pending_status}")
		
		sum_withdrawals = 0.0
		transactions.each do |t|
			sum_withdrawals += t.amount
		end

		if (present.balance - sum_withdrawals) < request
			return false
		end
			return true
	end

	def can_transfer(user1, user2,amount)
		user1_active_accounts = Account.where(:user_id => user1.id,:status => 1)
		user2_active_accounts = Account.where(:user_id => user2.id, :status => 1)
		if user1_active_accounts.size == 0 || user2_active_accounts.size == 0 || amount <= 0
			false
		else
			true
		end
	end

	def create_transaction_model(transfer_type, status, amount, account_id)
		transaction = Transaction.new
		transaction.transaction_type = transfer_type
        	transaction.status = status
        	transaction.start = Time.now
        	transaction.finish = Time.now
        	transaction.amount = amount
        	transaction.account_id = account_id
        	return transaction
	end

	def create_transfer_model(destination_account_id, transaction_id)
		transfer = Transfer.new
		transfer.account_id = destination_account_id
        transfer.transaction_id = transaction_id
        return transfer
	end

	def is_number? string
  		true if Float(string) rescue false
	end
end
