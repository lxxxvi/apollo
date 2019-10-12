require 'test_helper'

class Admin::Polls::StateChangesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :drafted_poll, :published_poll, :started_poll, :closed_poll

  setup do
    @drafted_poll = polls(:best_actress_drafted)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
  end

  test 'publish drafted' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state drafted_poll, :published
  end

  test 'start published' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state published_poll, :started
  end

  test 'close started' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state started_poll, :closed
  end

  test 'archive closed' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state closed_poll, :archived
  end

  test 'delete drafted' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state drafted_poll, :deleted
  end

  test 'delete published' do
    sign_in_as(:julia_roberts)
    assert_changes_to_state published_poll, :deleted
  end

  private

  def assert_changes_to_state(poll, next_state)
    assert_changes -> { poll.state }, to: next_state do
      post admin_poll_state_change_path(poll), params: { admin_poll_state_change: { next_state: next_state } }
      poll.reload
    end
  end
end
