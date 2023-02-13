class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present? && user.subscriptions.find_by(question: record.question).nil?
  end

  def destroy?
    user.present? && user.subscriptions.find_by(question: record.question).present?
  end
end
