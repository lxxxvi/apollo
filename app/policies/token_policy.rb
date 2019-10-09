class TokenPolicy < ApplicationPolicy
  def legit?
    record.poll.started? && !record.redeemed? && user.nil?
  end
end
