class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
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

  def mark_as_best?
    user&.author_of?(record.question)
  end

  def comment?
    user.present?
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
