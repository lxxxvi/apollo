require 'test_helper'

class Poll::StatesTest < ActiveSupport::TestCase
  attr_reader :user, :poll

  setup do
    @user = users(:julia_roberts)
    @poll = Poll.new(title: 'Foo', user: user)
  end

  test 'initial state' do
    assert_equal :draft, poll.state
  end

  test 'transition Draft to Published' do
    poll.save!

    assert_changes 'poll.state', from: :draft, to: :published do
      poll.publish!
    end
  end
end
