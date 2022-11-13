FactoryBot.define do
  factory :question do
    title { "Question_title" }
    body { "Question_body" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 3, question_id: question.id)
      end
    end
  end
end
