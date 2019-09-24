require 'test_helper'

class Admin::Polls::ClosingsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :started_poll, :closed_poll

  setup do
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
  end

  test 'admin can close closable poll' do
    sign_in_as(:julia_roberts)

    poll = started_poll

    assert_changes -> { poll.state }, from: :started, to: :closed do
      post admin_poll_closing_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll closed', flash[:notice]
  end

  test 'admin cannot close unclosable poll' do
    sign_in_as(:julia_roberts)

    poll = closed_poll

    assert_no_changes -> { poll.state } do
      post admin_poll_closing_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll is not closable', flash[:error]
  end

  test 'non-admin cannot close closable poll' do
    sign_in_as(:tina_fey)

    poll = started_poll

    assert_no_changes -> { poll.state } do
      assert_raise(ActiveRecord::RecordNotFound) { post admin_poll_closing_path(poll) }
      poll.reload
    end
  end

  test 'guest cannot close closable poll' do
    sign_out

    poll = started_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post admin_poll_closing_path(poll) }
      poll.reload
    end
  end
end
