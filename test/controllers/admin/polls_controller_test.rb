require 'test_helper'

class Admin::PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :drafted_poll, :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll

  setup do
    @drafted_poll = polls(:best_actress_drafted)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'admin get admin polls index' do
    sign_in_as(:julia_roberts)

    get admin_polls_path
    assert_response :success
  end

  test 'non-admin cannot get admin polls index' do
    sign_out

    assert_raise(Pundit::NotAuthorizedError) { get admin_polls_path }
  end

  test 'admin show published poll' do
    sign_in_as(:julia_roberts)

    get admin_poll_path(published_poll)
    assert_response :success
  end

  test 'admin should get manage polls' do
    sign_in_as(:julia_roberts)

    [drafted_poll, published_poll, started_poll, closed_poll, archived_poll].each do |poll|
      get admin_poll_path(poll)
      assert_response :success
    end
  end

  test 'admin should post update for unstarted poll' do
    sign_in_as(:julia_roberts)

    assert_changes -> { published_poll.reload.updated_at } do
      patch admin_poll_path(published_poll), params: {
        admin_poll: {
          title: 'Best Actress',
          description: 'Another description'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'admin updates schedule for unstarted poll' do
    sign_in_as(:julia_roberts)

    started_at_params = to_date_time_params(:started_at, 2018, 12, 11, 10, 9, 0)
    closed_at_params = to_date_time_params(:closed_at, 2019, 2, 3, 4, 5, 0)

    params = { time_zone: 'Sydney' }.merge(started_at_params, closed_at_params)

    assert_not_equal 'Sydney', published_poll.time_zone
    assert_not_equal DateTime.new(2018, 12, 11, 10, 9, 0, '+11').utc, published_poll.started_at
    assert_not_equal DateTime.new(2019, 2, 3, 4, 5, 0, '+11').utc, published_poll.closed_at

    patch admin_poll_path(published_poll), params: {
      poll_schedule: 'Update schedule',
      admin_poll: params
    }
    published_poll.reload

    assert_equal 'Sydney', published_poll.time_zone
    assert_equal DateTime.new(2018, 12, 11, 10, 9, 0, '+11').utc, published_poll.started_at
    assert_equal DateTime.new(2019, 2, 3, 4, 5, 0, '+11').utc, published_poll.closed_at

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
