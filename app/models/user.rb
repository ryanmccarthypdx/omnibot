class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  validates_presence_of   :email
  before_create :set_confirmation_code

  # Shooting for the 99.99% implementation from: https://www.regular-expressions.info/email.html
  validates :email, format: { with: /\A[a-z0-9!#$%&'*+\/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/ }

  after_create :send_welcome_email
  
  def send_welcome_email
    UserMailer.with(user_email: email,
                    confirmation_link: confirmation_link).welcome_email.deliver_now
  end

  private

  def set_confirmation_code
    self.confirmation_code = generate_confirmation_code
  end

  def generate_confirmation_code
    SecureRandom.hex(8)
  end

  def confirmation_link
    OmnibotConfig.full_hostname_with_protocol + "/confirm/" + confirmation_code
  end
end
