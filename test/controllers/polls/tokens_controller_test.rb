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

  test 'delete token' do
    sign_in_as(:julia_roberts)

    assert_difference -> { published_poll.tokens.count }, -1 do
      delete poll_token_path(published_poll, token)
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions for admin' do
    sign_in_as(:julia_roberts)

    [started_poll, closed_poll, archived_poll, deleted_poll].each do |poll|
      assert_not_get_new(Pundit::NotAuthorizedError, poll)
      assert_not_post(Pundit::NotAuthorizedError, poll)
      assert_not_delete(Pundit::NotAuthorizedError, poll)
    end
  end

  test 'unauthorized actions non-admin' do
    sign_in_as(:tina_fey)

    [published_poll, started_poll, closed_poll, archived_poll, deleted_poll].each do |poll|
      assert_not_get_new(ActiveRecord::RecordNotFound, poll)
      assert_not_post(ActiveRecord::RecordNotFound, poll)
      assert_not_delete(ActiveRecord::RecordNotFound, poll)
    end
  end

  test 'unauthorized actions guest' do
    sign_out

    [published_poll, started_poll, closed_poll, archived_poll, deleted_poll].each do |poll|
      assert_not_get_new(Pundit::NotAuthorizedError, poll)
      assert_not_post(Pundit::NotAuthorizedError, poll)
      assert_not_delete(Pundit::NotAuthorizedError, poll)
    end
  end

  private

  def assert_not_get_new(expected_exception, poll)
    assert_raise(expected_exception) { get new_poll_token_path(poll) }
  end

  def assert_not_post(expected_exception, poll)
    assert_raise(expected_exception) { post poll_tokens_path(poll) }
  end

  def assert_not_delete(expected_exception, poll)
    assert_raise(expected_exception) { delete poll_token_path(poll, token) }
  end
end
