class LinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user&.admin? || user&.author_of?(record.linkable)
  end
end