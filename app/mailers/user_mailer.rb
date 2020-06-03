class UserMailer < ApplicationMailer
  def welcome_email(user_email:, confirmation_code:)
    @headline = 'Welcome to The Omnibot!'
    @confirmation_link = generate_confirmation_link(confirmation_code)
    mail(to: user_email, subject: @headline, template_name: 'email_confirmation')
  end

  private

  def generate_confirmation_link(confirmation_code)
    OmnibotConfig.full_hostname_with_protocol + "/confirm/" + confirmation_code
  end
end
