class PollPolicy < ApplicationPolicy
  def index?
    true
  end

  def admin_index?
    user.present?
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
    admin? && record.editable?
  end

  def admin?
    record.user == user
  end

  def show_token?
    admin? && (record.published? || record.started?)
  end

  def update_schedule?
    record.closed_at.nil? || record.closed_at&.future?
  end

  class Scope < Scope
    def resolve
      if user.present?
        scope.of_user(user).not_deleted
      else
        scope.listed
      end
    end
  end
end
