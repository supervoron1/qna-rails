class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || user&.author_of?(record)
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end

  def like?
    user.present? && !user.author_of?(record) && record.votes.pluck(:user_id).exclude?(user.id)
  end

  def dislike?
    user.present? && !user.author_of?(record) && record.votes.pluck(:user_id).exclude?(user.id)
  end

  def cancel?
    user.present? && !user.author_of?(record) && record.votes.pluck(:user_id).include?(user.id)
  end
end
