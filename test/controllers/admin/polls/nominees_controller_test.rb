require 'test_helper'

class Admin::Polls::NomineesControllerTest < ActionDispatch::IntegrationTest
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

    get new_admin_poll_nominee_path(published_poll)
    assert_response :success
  end

  test 'create nominee' do
    sign_in_as(:julia_roberts)

    assert_difference -> { Nominee.count }, 1 do
      post admin_poll_nominees_path(published_poll), params: {
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

    get edit_admin_poll_nominee_path(published_poll, nominee)
    assert_response :success
  end

  test 'update nominee' do
    sign_in_as(:julia_roberts)

    assert_changes -> { nominee.name } do
      assert_changes -> { nominee.description } do
        patch admin_poll_nominee_path(published_poll, nominee), params: {
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
      delete admin_poll_nominee_path(published_poll, nominee)
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions admin' do
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
    assert_not_get_edit(poll, exception)
    assert_not_patch(poll, exception)
    assert_not_delete(poll, exception)
  end

  def assert_not_get_new(poll, exception)
    assert_raise(exception) { get new_admin_poll_nominee_path(poll) }
  end

  def assert_not_post(poll, exception)
    assert_raise(exception) { post admin_poll_nominees_path(poll) }
  end

  def assert_not_get_edit(poll, exception)
    assert_raise(exception) { get edit_admin_poll_nominee_path(poll, nominee) }
  end

  def assert_not_patch(poll, exception)
    assert_raise(exception) { patch admin_poll_nominee_path(poll, nominee) }
  end

  def assert_not_delete(poll, exception)
    assert_raise(exception) { delete admin_poll_nominee_path(poll, nominee) }
  end
end
