class AdminMailer < ApplicationMailer
	default from: "admin@bankapp.com"
	
	def transanction_status_mail(transaction)
		@transaction = transaction
		user = @transaction.account.user

		mail(to: user.email, subject: 'Admin action for the transaction')
	end

	def borrow_status_mail(transaction, transfer)
		@transaction = transaction
		@transfer = transfer
		friend = @transaction.account.user
		user = @transfer.account.user

		mail(to: friend.email, subject: 'Admin action for the transaction')
	end	

	def borrow_status_mail_friend(transaction, transfer)
		@transaction = transaction
		@transfer = transfer
		friend = @transaction.account.user
		user = @transfer.account.user

		mail(to: user.email, subject: 'Admin action for the transaction')
	end
end
