require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { belong_to :commentable }
  it { belong_to :user }

  it { should validate_presence_of :body }
end
