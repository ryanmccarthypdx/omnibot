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

  context 'before create' do
    let(:test_user) { FactoryBot.build(:user)}

    it 'sets a 16-character confirmation code' do
      expect(test_user.confirmation_code).to be nil
      test_user.run_callbacks :create
      expect(test_user.confirmation_code).to be_a(String)
      expect(test_user.confirmation_code.length).to eq(16)
    end
  end
end