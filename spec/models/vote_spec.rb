require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { belong_to :votable }
  it { belong_to :user }

  it { should validate_presence_of :value }
end