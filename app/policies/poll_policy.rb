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
    manage?
  end

  def destroy?
    update?
  end

  def manage?
    record.user == user
  end
end
