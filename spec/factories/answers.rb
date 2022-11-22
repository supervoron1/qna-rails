FactoryBot.define do
  factory :answer do
    body { "Answer_Body" }
    question
    user
  end

  trait :invalid do
    body { nil }
  end

  trait :with_file do
    files {[Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", "text/x-ruby")]}
  end
end
