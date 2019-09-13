require 'test_helper'

class Polls::PublishmentsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :draft_poll, :published_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
  end

  test 'admin publishes a poll' do
    sign_in_as(:julia_roberts)

    poll = draft_poll

    assert_changes -> { poll.state }, from: :draft, to: :published do
      post poll_publishment_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll published', flash[:notice]
  end

  test 'admin cannot publish unpublishable poll' do
    sign_in_as(:julia_roberts)

    poll = published_poll

    assert_no_changes -> { poll.state } do
      post poll_publishment_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll is not publishable', flash[:error]
  end

  test 'non-admin cannot publish a poll' do
    sign_in_as(:tina_fey)

    poll = draft_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post poll_publishment_path(poll) }
      poll.reload
    end
  end

  test 'guest cannot publish a poll' do
    poll = draft_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post poll_publishment_path(poll) }
      poll.reload
    end
  end
end
