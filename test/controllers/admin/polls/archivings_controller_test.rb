require 'test_helper'

class Admin::Polls::ArchivingsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :closed_poll, :archived_poll

  setup do
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
  end

  test 'admin can archive archivable poll' do
    sign_in_as(:julia_roberts)

    poll = closed_poll

    assert_changes -> { poll.state }, from: :closed, to: :archived do
      post admin_poll_archiving_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll archived', flash[:notice]
  end

  test 'admin cannot archive unarchivable poll' do
    sign_in_as(:julia_roberts)

    poll = archived_poll

    assert_no_changes -> { poll.state } do
      post admin_poll_archiving_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll is not archivable', flash[:error]
  end

  test 'non-admin cannot archive archivable poll' do
    sign_in_as(:tina_fey)

    poll = closed_poll

    assert_no_changes -> { poll.state } do
      assert_raise(ActiveRecord::RecordNotFound) { post admin_poll_archiving_path(poll) }
      poll.reload
    end
  end

  test 'guest cannot archive archivable poll' do
    sign_out

    poll = closed_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post admin_poll_archiving_path(poll) }
      poll.reload
    end
  end
end
