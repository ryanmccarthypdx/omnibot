FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@omnibot.com" }
    password { 'password' }
  end
end