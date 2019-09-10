require 'test_helper'

class Poll::States::PublishedTest < ActiveSupport::TestCase
  attr_reader :user, :poll

  setup do
    @user = users(:julia_roberts)
    @poll = Poll.new(title: 'Foo', user: user)
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

    assert_changes 'poll.published?', to: true do
      poll.publish!
    end
  end

  test '#publish! not publishable' do
    poll.published_at = Time.zone.now

    assert_raises(Error::PollStateChangeError) { poll.publish! }
  end
end
