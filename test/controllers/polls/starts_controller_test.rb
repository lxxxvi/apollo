require 'test_helper'

class Polls::StartsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :published_poll, :started_poll

  setup do
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
  end

  test 'admin can start startable poll' do
    sign_in_as(:julia_roberts)

    poll = published_poll

    assert_changes -> { poll.state }, from: :published, to: :started do
      post poll_start_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll started', flash[:notice]
  end

  test 'admin cannot start unstartable poll' do
    sign_in_as(:julia_roberts)

    poll = started_poll

    assert_no_changes -> { poll.state } do
      post poll_start_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll is not startable', flash[:error]
  end

  test 'non-admin cannot start startable poll' do
    sign_in_as(:tina_fey)

    poll = published_poll

    assert_no_changes -> { poll.state } do
      assert_raise(ActiveRecord::RecordNotFound) { post poll_start_path(poll) }
      poll.reload
    end
  end

  test 'guest cannot start startable poll' do
    sign_out

    poll = published_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post poll_start_path(poll) }
      poll.reload
    end
  end
end
