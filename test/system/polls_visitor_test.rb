require 'application_system_test_case'

class PollsVisitorTest < ApplicationSystemTestCase
  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @archived_poll = polls(:best_song_archived)
  end

  test 'guest does not see archived poll on index' do
    sign_out

    visit polls_path
    assert_selector '.poll .poll-state', minimum: 1
    assert_not all('.poll .poll-state').map(&:text).map(&:downcase).include?('archived'),
               'Archived polls should not appear on index'
  end

  test 'guest can visit an archived poll' do
    sign_out

    visit poll_path(@archived_poll)
    assert_selector 'h1', text: 'Best song'
  end

  test 'non-admin cannot visit a published poll' do
    sign_in_as(:tina_fey)
    assert_no_visit_poll @published_poll
  end

  test 'guest visits a published poll' do
    sign_out

    assert_visit_poll @published_poll
  end

  test 'guest cannot visit an unlisted poll' do
    sign_out
    assert_no_visit_poll @draft_poll
  end

  private

  def assert_no_visit_poll(poll)
    assert_raise(ActiveRecord::RecordNotFound) { visit admin_poll_path(poll) }
  end

  def assert_visit_poll(poll)
    visit poll_path(poll)

    assert_selector 'h1', text: 'Best actor'
    assert_selector 'p', text: 'Who is he?'
    assert_selector '.nominee', text: 'Bryan Cranston'

    assert_no_manage

    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  def assert_no_manage
    assert_selector 'a', text: 'Manage', count: 0
  end
end
