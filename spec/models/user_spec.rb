require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }

    context 'uniqueness' do
      before { FactoryBot.create(:user) }
      it { should validate_uniqueness_of(:email) }
    end
  end

  it { should have_secure_password }
end