require 'test_helper'

class StatableTest < ActiveSupport::TestCase
  attr_reader :user, :draft_poll, :published_poll,
              :started_poll, :closed_poll, :archived_poll,
              :deleted_poll

  setup do
    @user = users(:julia_roberts)
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'initial state' do
    assert_equal :draft, Poll.new(title: 'Foo', user: user).state
  end

  # publish

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
    assert_raises(Error::PollStateChangeError) { started_poll.publish! }
    assert_raises(Error::PollStateChangeError) { closed_poll.publish! }
    assert_raises(Error::PollStateChangeError) { archived_poll.publish! }
    assert_raises(Error::PollStateChangeError) { deleted_poll.publish! }
  end

  # start

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
    assert_raises(Error::PollStateChangeError) { closed_poll.start! }
    assert_raises(Error::PollStateChangeError) { archived_poll.start! }
    assert_raises(Error::PollStateChangeError) { deleted_poll.start! }
  end

  # close

  test 'closable?' do
    assert started_poll.closable?
  end

  test 'scope, state, state check for close!' do
    poll = started_poll

    assert_difference 'Poll.closed.count', 1 do
      assert_changes 'poll.closed?', to: true do
        assert_changes 'poll.state', from: :started, to: :closed do
          poll.close!
        end
      end
    end
  end

  test '#close! not closable' do
    assert_raises(Error::PollStateChangeError) { draft_poll.close! }
    assert_raises(Error::PollStateChangeError) { published_poll.close! }
    assert_raises(Error::PollStateChangeError) { closed_poll.close! }
    assert_raises(Error::PollStateChangeError) { archived_poll.close! }
    assert_raises(Error::PollStateChangeError) { deleted_poll.close! }
  end

  # archive

  test 'archivable?' do
    assert closed_poll.archivable?
  end

  test 'scope, state, state check for archive!' do
    poll = closed_poll

    assert_difference 'Poll.archived.count', 1 do
      assert_changes 'poll.archived?', to: true do
        assert_changes 'poll.state', from: :closed, to: :archived do
          poll.archive!
        end
      end
    end
  end

  test '#archive! not archivable' do
    assert_raises(Error::PollStateChangeError) { draft_poll.archive! }
    assert_raises(Error::PollStateChangeError) { published_poll.archive! }
    assert_raises(Error::PollStateChangeError) { started_poll.archive! }
    assert_raises(Error::PollStateChangeError) { archived_poll.archive! }
    assert_raises(Error::PollStateChangeError) { deleted_poll.archive! }
  end

  # delete

  test 'deletable?' do
    assert draft_poll.deletable?
    assert published_poll.deletable?
  end

  test 'scope, state, state check for delete!' do
    poll = published_poll

    assert_difference 'Poll.deleted.count', 1 do
      assert_changes 'poll.deleted?', to: true do
        assert_changes 'poll.state', from: :published, to: :deleted do
          poll.delete!
        end
      end
    end
  end

  test '#delete! not deletable' do
    assert_raises(Error::PollStateChangeError) { started_poll.delete! }
    assert_raises(Error::PollStateChangeError) { closed_poll.delete! }
    assert_raises(Error::PollStateChangeError) { archived_poll.delete! }
  end
end
