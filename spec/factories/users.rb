FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { 'strong_password' }
    password_confirmation { 'strong_password' }
  end
end
