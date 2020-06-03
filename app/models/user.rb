class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  validates_presence_of   :email
  before_create :generate_confirmation_code

  # Shooting for the 99.99% implementation from: https://www.regular-expressions.info/email.html
  validates :email, format: { with: /\A[a-z0-9!#$%&'*+\/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/ }

  private

  def generate_confirmation_code
    self.confirmation_code = SecureRandom.hex(8)
  end
end
