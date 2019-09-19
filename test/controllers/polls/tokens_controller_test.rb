require 'test_helper'

class Polls::TokensControllerTest < ActionDispatch::IntegrationTest
  attr_reader :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll, :token

  setup do
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
    @token = tokens(:best_actor_token_1)
  end

  test 'get new token' do
    sign_in_as(:julia_roberts)

    get new_poll_token_path(published_poll)
    assert_response :success
  end

  test 'create token' do
    sign_in_as(:julia_roberts)

    assert_difference -> { published_poll.tokens.count }, 1 do
      post poll_tokens_path(published_poll), params: {
        poll_token: { amount: 1 }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions for admin' do
    sign_in_as(:julia_roberts)

    assert_all_exceptions(started_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(closed_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(archived_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  test 'unauthorized actions non-admin' do
    sign_in_as(:tina_fey)

    assert_all_exceptions(published_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(started_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(closed_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(archived_poll, ActiveRecord::RecordNotFound)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  test 'unauthorized actions guest' do
    sign_out

    assert_all_exceptions(published_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(started_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(closed_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(archived_poll, Pundit::NotAuthorizedError)
    assert_all_exceptions(deleted_poll, ActiveRecord::RecordNotFound)
  end

  private

  def assert_all_exceptions(poll, exception)
    assert_not_get_new(poll, exception)
    assert_not_post(poll, exception)
  end

  def assert_not_get_new(poll, exception)
    assert_raise(exception) { get new_poll_token_path(poll) }
  end

  def assert_not_post(poll, exception)
    assert_raise(exception) { post poll_tokens_path(poll) }
  end
end
