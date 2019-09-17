require 'test_helper'

class Polls::NomineesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll, :nominee

  setup do
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
    @nominee = nominees(:best_actor_bill_murray)
  end

  test 'new nominee' do
    sign_in_as(:julia_roberts)

    get new_poll_nominee_path(published_poll)
    assert_response :success
  end

  test 'create nominee' do
    sign_in_as(:julia_roberts)

    assert_difference -> { Nominee.count }, 1 do
      post poll_nominees_path(published_poll), params: {
        nominee: {
          name: 'John Malkovich',
          description: 'Being John Malkovich'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'edit nominee' do
    sign_in_as(:julia_roberts)

    get edit_poll_nominee_path(published_poll, nominee)
    assert_response :success
  end

  test 'update nominee' do
    sign_in_as(:julia_roberts)

    assert_changes -> { nominee.name } do
      assert_changes -> { nominee.description } do
        patch poll_nominee_path(published_poll, nominee), params: {
          nominee: {
            name: 'Bill Ghost-Bustin Murray',
            description: 'He aint afraid of no ghost'
          }
        }
        nominee.reload
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'delete nominee' do
    sign_in_as(:julia_roberts)

    assert_difference -> { Nominee.count }, -1 do
      delete poll_nominee_path(published_poll, nominee)
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions admin' do
    sign_in_as(:julia_roberts)

    [
      [started_poll, Pundit::NotAuthorizedError],
      [closed_poll, Pundit::NotAuthorizedError],
      [archived_poll, Pundit::NotAuthorizedError],
      [deleted_poll, ActiveRecord::RecordNotFound]
    ].map(&method(:assert_all_exceptions))
  end

  test 'unauthorized actions non-admin' do
    sign_in_as(:tina_fey)

    [
      [published_poll, ActiveRecord::RecordNotFound],
      [started_poll, ActiveRecord::RecordNotFound],
      [closed_poll, ActiveRecord::RecordNotFound],
      [archived_poll, ActiveRecord::RecordNotFound],
      [deleted_poll, ActiveRecord::RecordNotFound]
    ].map(&method(:assert_all_exceptions))
  end

  test 'unauthorized actions guest' do
    sign_out

    [
      [published_poll, Pundit::NotAuthorizedError],
      [started_poll, Pundit::NotAuthorizedError],
      [closed_poll, Pundit::NotAuthorizedError],
      [archived_poll, Pundit::NotAuthorizedError],
      [deleted_poll, ActiveRecord::RecordNotFound]
    ].map(&method(:assert_all_exceptions))
  end

  private

  def assert_all_exceptions(row)
    poll, exception = row
    assert_not_get_new(exception, poll)
    assert_not_post(exception, poll)
    assert_not_get_edit(exception, poll)
    assert_not_patch(exception, poll)
    assert_not_delete(exception, poll)
  end

  def assert_not_get_new(expected_exception, poll)
    assert_raise(expected_exception) { get new_poll_nominee_path(poll) }
  end

  def assert_not_post(expected_exception, poll)
    assert_raise(expected_exception) { post poll_nominees_path(poll) }
  end

  def assert_not_get_edit(expected_exception, poll)
    assert_raise(expected_exception) { get edit_poll_nominee_path(poll, nominee) }
  end

  def assert_not_patch(expected_exception, poll)
    assert_raise(expected_exception) { patch poll_nominee_path(poll, nominee) }
  end

  def assert_not_delete(expected_exception, poll)
    assert_raise(expected_exception) { delete poll_nominee_path(poll, nominee) }
  end
end
