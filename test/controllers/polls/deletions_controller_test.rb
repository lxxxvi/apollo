require 'test_helper'

class Polls::DeletionsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :published_poll, :deleted_poll

  setup do
    @published_poll = polls(:best_actor_published)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'admin can delete deletable poll' do
    sign_in_as(:julia_roberts)

    poll = published_poll

    assert_changes -> { poll.state }, from: :published, to: :deleted do
      post poll_deletion_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll deleted', flash[:notice]
  end

  test 'admin cannot delete undeletable poll' do
    sign_in_as(:julia_roberts)

    poll = deleted_poll

    assert_no_changes -> { poll.state } do
      post poll_deletion_path(poll)
      poll.reload
    end

    follow_redirect!
    assert_response :success

    assert_equal 'Poll is not deletable', flash[:error]
  end

  test 'non-admin cannot delete deletable poll' do
    sign_in_as(:tina_fey)

    poll = published_poll

    assert_no_changes -> { poll.state } do
      assert_raise(ActiveRecord::RecordNotFound) { post poll_deletion_path(poll) }
      poll.reload
    end
  end

  test 'guest cannot delete deletable poll' do
    sign_out

    poll = published_poll

    assert_no_changes -> { poll.state } do
      assert_raise(Pundit::NotAuthorizedError) { post poll_deletion_path(poll) }
      poll.reload
    end
  end
end
