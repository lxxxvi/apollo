require 'test_helper'

class PollPolicyTest < ActiveSupport::TestCase
  attr_reader :guest, :poll, :poll_admin, :another_admin

  setup do
    @guest = '_guest'
    @poll = polls(:best_actor)
    @poll_admin = @poll.user
    @another_admin = users(:tina_fey)
  end

  test '#index?' do
    assert_permit guest, Poll, :index?
  end

  test '#show?' do
    assert_permit guest, Poll, :show?
  end

  test '#new?' do
    assert_permit guest, Poll, :new?
  end

  test '#create?' do
    assert_permit guest, Poll, :create?
  end

  test '#edit?' do
    refute_permit guest, poll, :edit?
    refute_permit another_admin, poll, :edit?
    assert_permit poll_admin, poll, :edit?
  end

  test '#update?' do
    refute_permit guest, poll, :update?
    refute_permit another_admin, poll, :update?
    assert_permit poll_admin, poll, :update?
  end

  test '#destroy?' do
    refute_permit guest, poll, :destroy?
    refute_permit another_admin, poll, :destroy?
    assert_permit poll_admin, poll, :destroy?
  end
end
