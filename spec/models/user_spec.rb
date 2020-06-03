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

  context 'callbacks' do
    let(:test_user) { FactoryBot.build(:user)}

    context 'before create' do
      it 'sets a 16-character confirmation code' do
        expect(test_user.confirmation_code).to be nil
        test_user.run_callbacks :create
        expect(test_user.confirmation_code).to be_a(String)
        expect(test_user.confirmation_code.length).to eq(16)
      end
    end

    context 'after create' do
      let(:test_confirmation_code) { 'iamsixteendigits' }

      before do
        allow(test_user).to receive(:generate_confirmation_code).and_return(test_confirmation_code)
        allow(UserMailer).to receive(:welcome_email).and_call_original
      end 

      it "tells UserMailer to send a welcome email with the user's email and confirmation code" do
        test_user.save
        expect(UserMailer).to have_received(:welcome_email).with(user_email: test_user.email, confirmation_code: test_confirmation_code)
      end

      it "tells UserMailer to send the email right away" do
        expect{ test_user.save }.to change{ ActionMailer::Base.deliveries.count }.by 1
      end
    end
  end
end