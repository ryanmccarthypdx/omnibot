class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :email
  validates_presence_of   :email
  before_create :generate_confirmation_code

  private

  def generate_confirmation_code
    self.confirmation_code = SecureRandom.hex(8)
  end
end
