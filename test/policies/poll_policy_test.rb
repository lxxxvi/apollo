require 'test_helper'

class PollPolicyTest < ActiveSupport::TestCase
  attr_reader :guest

  setup do
    @guest = '_guest'
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
    skip
    refute_permit guest, Poll, :edit?
  end

  test '#update?' do
    skip
    refute_permit guest, Poll, :update?
  end

  test '#destroy?' do
    skip
    refute_permit guest, Poll, :destroy?
  end
end
