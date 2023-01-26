shared_examples_for 'Votable Policy' do
  permissions :like? do
    it 'grants access if user is not author of votable and did\'t vote before' do
      expect(subject).to permit(user, votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(factory_name, user: user))
    end

    it 'denies access if user voted before' do
      user = create(:user)
      create(:vote, votable: votable, user: user)
      expect(subject).to_not permit(user, votable)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, votable)
    end
  end

  permissions :dislike? do
    it 'grants access if user is not author of votable and did\'t vote before' do
      expect(subject).to permit(user, votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(factory_name, user: user))
    end

    it 'denies access if user voted before' do
      user = create(:user)
      create(:vote, votable: votable, user: user)
      expect(subject).to_not permit(user, votable)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, votable)
    end
  end

  permissions :cancel? do
    it 'grants access if user voted before' do
      user = create(:user)
      create(:vote, votable: votable, user: user)
      expect(subject).to permit(user, votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, create(factory_name, user: user))
    end

    it 'denies access if user is not author of votable and did\'t vote before' do
      expect(subject).to_not permit(user, votable)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, votable)
    end
  end
end
