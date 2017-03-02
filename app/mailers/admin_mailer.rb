class AdminMailer < ApplicationMailer
	default from: "admin@bankapp.com"
	
	def transanction_status_mail(transaction)
		@transaction = transaction
		user = @transaction.account.user

		mail(to: user.email, subject: 'Admin action for the transaction')
	end	
end
