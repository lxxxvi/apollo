require 'test_helper'

class StatableTest < ActiveSupport::TestCase
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

  test '#publishable?' do
    poll.published_at = nil
    poll.user.email_verified_at = nil
    assert_not poll.publishable?, 'Should not be publishable because user is not verified'

    poll.user.email_verified_at = Time.zone.now
    assert poll.publishable?, 'Should be publishable because user is verifed, and it is not published yet'

    poll.published_at = Time.zone.now
    assert_not poll.publishable?, 'Should not be publishable, because it already is published'
  end

  test '#publish!' do
    poll.published_at = nil

    assert_difference 'Poll.published.count', 1 do
      assert_changes 'poll.published?', to: true do
        poll.publish!
      end
    end
  end

  test '#publish! not publishable' do
    poll.published_at = Time.zone.now

    assert_raises(Error::PollStateChangeError) { poll.publish! }
  end
end