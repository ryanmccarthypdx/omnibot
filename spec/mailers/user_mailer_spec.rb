require 'rails_helper'

describe UserMailer, type: :mailer do
  describe '#welcome_email' do
    let(:test_confirmation_code) { '1234567890123456' }
    let(:test_user_email_address) { 'test@example.com' }
    let(:test_email) { UserMailer.welcome_email(user_email: test_user_email_address, confirmation_code: test_confirmation_code) }

    it 'should send an email with the appropriate recipient, from address, and subject line' do
      expect(test_email.to).to eq([test_user_email_address])
      expect(test_email.from).to eq ["noreply@theomnibot.com"]
      expect(test_email.subject).to eq  "Welcome to The Omnibot!"
    end

    it 'should send out a multipart text/html email with the headline and the correct confirmation url in each' do
      expect(test_email.parts.map(&:content_type)).to contain_exactly("text/html; charset=UTF-8", "text/plain; charset=UTF-8")
      test_email.parts.each do |p| 
        expect(p.body.raw_source).to include('http://theomnibot.com/confirm/1234567890123456')
      end
    end
  end
end