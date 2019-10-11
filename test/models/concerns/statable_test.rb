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

  test 'valid state transitions' do
    assert @draft_poll.transit_to!(:published)
    assert @published_poll.transit_to!(:started)
    assert @started_poll.transit_to!(:closed)
    assert @closed_poll.transit_to!(:archived)
  end

  test 'valid state deletions' do
    assert @draft_poll.transit_to!(:deleted)
    assert @published_poll.transit_to!(:deleted)
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

    assert_raise(ActiveRecord::RecordInvalid) { poll.transit_to!(:published) }
    assert_includes poll.errors, :user

    poll.user.email_verified_at = Time.zone.now
    poll.transit_to!(:published)
    assert poll.valid?
  end

  test 'scope, state, state check for publish!' do
    poll = draft_poll

    assert_changes 'poll.published?', to: true do
      assert_changes 'poll.state', from: :draft, to: :published do
        poll.transit_to!(:published)
      end
    end
  end

  test '#publish not publishable' do
    assert_raise(InvalidStateTransition) { started_poll.transit_to!(:publish) }
    assert_raise(InvalidStateTransition) { closed_poll.transit_to!(:publish) }
    assert_raise(InvalidStateTransition) { archived_poll.transit_to!(:publish) }
    assert_raise(InvalidStateTransition) { deleted_poll.transit_to!(:publish) }
  end

  # start

  test 'scope, state, state check for start!' do
    poll = published_poll

    assert_changes 'poll.started?', to: true do
      assert_changes 'poll.state', from: :published, to: :started do
        poll.transit_to!(:started)
      end
    end
  end

  test '#start not startable' do
    assert_raise(InvalidStateTransition) { draft_poll.transit_to!(:started) }
    assert_raise(InvalidStateTransition) { closed_poll.transit_to!(:started) }
    assert_raise(InvalidStateTransition) { archived_poll.transit_to!(:started) }
    assert_raise(InvalidStateTransition) { deleted_poll.transit_to!(:started) }
  end

  # close

  test 'state, state check for close!' do
    poll = started_poll

    assert_changes 'poll.closed?', to: true do
      assert_changes 'poll.state', from: :started, to: :closed do
        poll.transit_to!(:closed)
      end
    end
  end

  test '#close! not closable' do
    assert_raise(InvalidStateTransition) { draft_poll.transit_to!(:closed) }
    assert_raise(InvalidStateTransition) { published_poll.transit_to!(:closed) }
    assert_raise(InvalidStateTransition) { archived_poll.transit_to!(:closed) }
    assert_raise(InvalidStateTransition) { deleted_poll.transit_to!(:closed) }
  end

  # archive

  test 'scope, state, state check for archive!' do
    poll = closed_poll

    assert_changes 'poll.archived?', to: true do
      assert_changes 'poll.state', from: :closed, to: :archived do
        poll.transit_to!(:archived)
      end
    end
  end

  test '#archive not archivable' do
    assert_raise(InvalidStateTransition) { draft_poll.transit_to!(:archived) }
    assert_raise(InvalidStateTransition) { published_poll.transit_to!(:archived) }
    assert_raise(InvalidStateTransition) { started_poll.transit_to!(:archived) }
    assert_raise(InvalidStateTransition) { deleted_poll.transit_to!(:archived) }
  end

  # delete

  test 'state, state check for delete!' do
    poll = published_poll

    assert_changes 'poll.deleted?', to: true do
      assert_changes 'poll.state', from: :published, to: :deleted do
        poll.transit_to!(:deleted)
      end
    end
  end

  test '#delete not deletable' do
    assert_raise(InvalidStateTransition) { started_poll.transit_to!(:delete) }
    assert_raise(InvalidStateTransition) { closed_poll.transit_to!(:delete) }
    assert_raise(InvalidStateTransition) { archived_poll.transit_to!(:delete) }
  end
end
