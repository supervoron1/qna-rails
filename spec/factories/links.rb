FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://google.com" }
    linkable { Question.new }
  end
end
