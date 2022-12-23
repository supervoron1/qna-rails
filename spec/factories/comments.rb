FactoryBot.define do
  factory :comment do
    body { 'Comment body' }
  end

  trait :invalid_comment do
    body { nil }
  end
end
