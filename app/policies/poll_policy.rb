class PollPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    manage? && record.editable?
  end

  def manage?
    record.user == user
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.of_user(user)
      else
        scope.listed
      end
    end
  end
end
