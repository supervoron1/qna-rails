FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    question
    answer

    after(:build) do |reward|
      reward.image.attach(
        io:           File.open("#{Rails.root}/spec/support/files/reward.png"),
        filename:     'reward.png',
        content_type: 'image/png'
      )
    end
  end
end
