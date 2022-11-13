FactoryBot.define do
  factory :answer do
    body { "Answer_Body" }
    question
    user
  end

  trait :invalid do
    body { nil }
  end
end
