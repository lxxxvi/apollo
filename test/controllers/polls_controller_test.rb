require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :draft_poll, :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'show published poll' do
    get poll_path(published_poll)
    assert_response :success
  end

  test 'new poll' do
    get new_poll_path
    assert_response :success
  end

  test 'create poll' do
    assert_difference -> { User.count }, 1 do
      assert_difference -> { Poll.count }, 1 do
        post polls_path, params: {
          poll: {
            title: 'The poll name',
            email: 'email@apollo.test',
            description: 'A description'
          }
        }
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'admin should get manage polls' do
    sign_in_as(:julia_roberts)

    [draft_poll, published_poll, started_poll, closed_poll, archived_poll].each do |poll|
      get manage_poll_path(poll)
      assert_response :success
    end
  end

  test 'admin should post update for unstarted poll' do
    sign_in_as(:julia_roberts)

    assert_changes -> { published_poll.reload.updated_at } do
      patch poll_path(published_poll), params: {
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

    [started_poll, closed_poll, archived_poll, deleted_poll].map do |poll|
      assert_not_patch_poll Pundit::NotAuthorizedError, poll
    end
  end

  test 'unauthorized actions for non-admin' do
    sign_in_as(:tina_fey)

    [published_poll, started_poll, closed_poll, archived_poll, deleted_poll].map do |poll|
      assert_not_get_manage(ActiveRecord::RecordNotFound, poll)
      assert_not_patch_poll(ActiveRecord::RecordNotFound, poll)
    end
  end

  test 'unauthorized actions for guest' do
    sign_out

    [published_poll, started_poll, closed_poll, archived_poll, deleted_poll].map do |poll|
      assert_not_get_manage Pundit::NotAuthorizedError, poll
      assert_not_patch_poll Pundit::NotAuthorizedError, poll
    end
  end

  private

  def assert_not_get_manage(expected_exception, poll)
    assert_raise(expected_exception) { get manage_poll_path(poll) }
  end

  def assert_not_patch_poll(expected_exception, poll)
    assert_raise(expected_exception) { patch poll_path(poll) }
  end
end
