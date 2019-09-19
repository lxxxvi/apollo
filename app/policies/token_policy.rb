class TokenPolicy < ApplicationPolicy
  def legit?
    record.poll.started? && record.unused? && user.nil?
  end
end
