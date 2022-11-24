require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'validate url when it is' do
    it 'correct' do
      expect { create(:link, url: 'https://google.com/search?q=test').to_not raise_error(URI::InvalidURIError) }
    end

    it 'incorrect' do
      expect { create(:link, url: 'incorrectURL').to raise_error(URI::InvalidURIError) }
    end
  end
end
