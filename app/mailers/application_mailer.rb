class ApplicationMailer < ActionMailer::Base
  default from: "admin@bankapp.com"

  layout 'mailer'
end
