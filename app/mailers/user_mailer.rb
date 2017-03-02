class UserMailer < ApplicationMailer
	default from: "admin@bankapp.com"

	def transaction_status_mail(transfer)
		@transfer = transfer
		@transaction = Transaction.find(transfer.transaction_id)
		user = @transaction.account.user

		mail(to: user.email, subject: 'Transfer to Friend')
	end
end
