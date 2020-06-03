class ApplicationMailer < ActionMailer::Base
  default from: (OmnibotConfig.from_email_local_part + "@" + OmnibotConfig.hostname)
  layout 'mailer'
end
