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
    assert_equal 'draft', Poll.new(title: 'Foo', user: user).state
  end

  test 'valid state transitions' do
    assert @draft_poll.publish
    assert @published_poll.start
    assert @started_poll.close
    assert @closed_poll.archive
  end

  test 'valid state deletions' do
    assert @draft_poll.delete
    assert @published_poll.delete
  end

  test '#editable?' do
    assert draft_poll.editable?
    assert published_poll.editable?
    assert_not started_poll.editable?
    assert_not closed_poll.editable?
    assert_not archived_poll.editable?
    assert_not deleted_poll.editable?
  end

  test '#next_state' do
    assert_equal :published, @draft_poll.next_state
    assert_equal :started, @published_poll.next_state
    assert_equal :closed, @started_poll.next_state
    assert_equal :archived, @closed_poll.next_state
    assert_nil @archived_poll.next_state
  end

  # publish

  test '#verified_user' do
    poll = draft_poll
    poll.user.email_verified_at = nil

    assert_not poll.publish
    assert_includes poll.errors, :user

    poll.user.email_verified_at = Time.zone.now
    assert poll.publish
  end

  test 'scope, state, state check for publish!' do
    poll = draft_poll

    assert_difference 'Poll.published.count', 1 do
      assert_changes 'poll.published?', to: true do
        assert_changes 'poll.state', from: 'draft', to: 'published' do
          poll.publish
        end
      end
    end
  end

  test '#publish not publishable' do
    assert_not started_poll.publish
    assert_not closed_poll.publish
    assert_not archived_poll.publish
    assert_not deleted_poll.publish
  end

  # start

  test 'scope, state, state check for start!' do
    poll = published_poll

    assert_difference 'Poll.started.count', 1 do
      assert_changes 'poll.started?', to: true do
        assert_changes 'poll.state', from: 'published', to: 'started' do
          poll.start
        end
      end
    end
  end

  test '#start not startable' do
    assert_not draft_poll.start
    assert_not closed_poll.start
    assert_not archived_poll.start
    assert_not deleted_poll.start
  end

  # close

  test 'scope, state, state check for close!' do
    poll = started_poll

    assert_difference 'Poll.closed.count', 1 do
      assert_changes 'poll.closed?', to: true do
        assert_changes 'poll.state', from: 'started', to: 'closed' do
          poll.close
        end
      end
    end
  end

  test '#close! not closable' do
    assert_not draft_poll.close
    assert_not published_poll.close
    assert_not archived_poll.close
    assert_not deleted_poll.close
  end

  # archive

  test 'scope, state, state check for archive!' do
    poll = closed_poll

    assert_difference 'Poll.archived.count', 1 do
      assert_changes 'poll.archived?', to: true do
        assert_changes 'poll.state', from: 'closed', to: 'archived' do
          poll.archive
        end
      end
    end
  end

  test '#archive not archivable' do
    assert_not draft_poll.archive
    assert_not published_poll.archive
    assert_not started_poll.archive
    assert_not deleted_poll.archive
  end

  # delete

  test 'scope, state, state check for delete!' do
    poll = published_poll

    assert_difference 'Poll.deleted.count', 1 do
      assert_changes 'poll.deleted?', to: true do
        assert_changes 'poll.state', from: 'published', to: 'deleted' do
          poll.delete
        end
      end
    end
  end

  test '#delete not deletable' do
    assert_not started_poll.delete
    assert_not closed_poll.delete
    assert_not archived_poll.delete
  end
end
