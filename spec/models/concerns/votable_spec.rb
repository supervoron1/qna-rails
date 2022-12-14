require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:model) { described_class }
  let!(:votable) { create(model.to_s.underscore.to_sym) }
  let!(:user) { create(:user) }
  let!(:vote_pos_first) { create(:vote, user: user, votable: votable, value: 1) }
  let!(:vote_pos_second) { create(:vote, user: user, votable: votable, value: 1) }
  let!(:vote_neg) { create(:vote, user: user, votable: votable, value: -1) }

  it '#rating' do
    expect(votable.rating).to eq(1)
  end
end