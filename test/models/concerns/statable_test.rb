require 'test_helper'

class StatableTest < ActiveSupport::TestCase
  attr_reader :user, :draft_poll, :published_poll, :started_poll

  setup do
    @user = users(:julia_roberts)
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
  end

  test 'initial state' do
    assert_equal :draft, Poll.new(title: 'Foo', user: user).state
  end

  test '#publishable?' do
    poll = draft_poll
    poll.user.email_verified_at = nil
    assert_not poll.publishable?, 'Should not be publishable because user is not verified'

    poll.user.email_verified_at = Time.zone.now
    assert poll.publishable?, 'Should be publishable because user is verifed, and it is not published yet'

    poll.published_at = Time.zone.now
    assert_not poll.publishable?, 'Should not be publishable, because it already is published'
  end

  test 'scope, state, state check for publish!' do
    poll = draft_poll

    assert_difference 'Poll.published.count', 1 do
      assert_changes 'poll.published?', to: true do
        assert_changes 'poll.state', from: :draft, to: :published do
          poll.publish!
        end
      end
    end
  end

  test '#publish! not publishable' do
    assert_raises(Error::PollStateChangeError) { published_poll.publish! }
  end

  test '#startable?' do
    assert published_poll.startable?
  end

  test 'scope, state, state check for start!' do
    poll = published_poll

    assert_difference 'Poll.started.count', 1 do
      assert_changes 'poll.started?', to: true do
        assert_changes 'poll.state', from: :published, to: :started do
          poll.start!
        end
      end
    end
  end

  test '#start! not startable' do
    assert_raises(Error::PollStateChangeError) { draft_poll.start! }
    assert_raises(Error::PollStateChangeError) { started_poll.start! }
  end
end
