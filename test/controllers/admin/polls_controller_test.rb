require 'test_helper'

class Admin::PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :draft_poll, :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'admin show published poll' do
    sign_in_as(:julia_roberts)

    get admin_poll_path(published_poll)
    assert_response :success
  end

  test 'admin should get manage polls' do
    sign_in_as(:julia_roberts)

    [draft_poll, published_poll, started_poll, closed_poll, archived_poll].each do |poll|
      get admin_poll_path(poll)
      assert_response :success
    end
  end

  test 'admin should post update for unstarted poll' do
    sign_in_as(:julia_roberts)

    assert_changes -> { published_poll.reload.updated_at } do
      patch admin_poll_path(published_poll), params: {
        poll: {
          title: 'Best Actress',
          description: 'Another description'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions for admin once poll started' do
    sign_in_as(:julia_roberts)

    assert_not_patch_poll(started_poll, Pundit::NotAuthorizedError)
    assert_not_patch_poll(closed_poll, Pundit::NotAuthorizedError)
    assert_not_patch_poll(archived_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  test 'unauthorized actions for non-admin' do
    sign_in_as(:tina_fey)

    assert_all_exceptions(published_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(started_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(closed_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(archived_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  test 'unauthorized actions for guest' do
    sign_out

    assert_all_exceptions(published_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(started_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(closed_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(archived_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  private

  def assert_all_exceptions(poll, exception)
    assert_not_get_show(poll, exception)
    assert_not_patch_poll(poll, exception)
  end

  def assert_not_get_show(poll, exception)
    assert_raise(exception, build_exception(poll.state, __method__)) { get admin_poll_path(poll) }
  end

  def assert_not_patch_poll(poll, exception)
    assert_raise(exception, build_exception(poll.state, __method__)) { patch admin_poll_path(poll) }
  end

  def build_exception(state, method_name)
    "Poll state: #{state}\nMethod: #{method_name}"
  end
end
