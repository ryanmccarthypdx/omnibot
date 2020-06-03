require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }

    context 'uniqueness' do
      before { FactoryBot.create(:user) }
      it { should validate_uniqueness_of(:email) }
    end

    context 'email format' do
      let(:test_user) { FactoryBot.build(:user)}
      context 'valid emails' do
        [
          "abc@d.com",
          "a@abc.com",
          "12345678901234567890@1234.12345",
          "a.b.c.d@1.1",
          "a_b_c@d.reallylongtopleveldomain"
        ].each do |test_email|
          it "allows #{test_email}" do
            test_user.email = test_email
            expect(test_user).to be_valid
          end
        end
      end 

      context 'invalid emails' do
        [
          ".a@d.com",
          "a@.gmail.com",
          "no.at.signs",
          "a.....z@x.com",
          "a@a....z.com",
        ].each do |test_email|
          it "disallows #{test_email}" do
            test_user.email = test_email
            expect(test_user).not_to be_valid
          end
        end
      end
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

  context 'after create' do
    let(:test_user) { FactoryBot.build(:user) }
    let(:expected_confirmation_link) { OmnibotConfig.full_hostname_with_protocol + "/confirm/iamsixteendigits"}

    before do
      allow(test_user).to receive(:generate_confirmation_code).and_return('iamsixteendigits')
    end 

    it 'tells UserMailer to send a welcome email' do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      test_user.save
    end

    it 'passes UserMailer the correct confirmation link' do 
      expect(UserMailer).to receive(:with).with(user_email: test_user.email, confirmation_link: expected_confirmation_link).and_call_original
      test_user.save
    end
  end
end