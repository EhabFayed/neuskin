class ApplicationMailer < ActionMailer::Base
  default from: Clinic::MAIL_FROM
  layout "mailer"
end
