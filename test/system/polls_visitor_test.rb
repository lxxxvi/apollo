require 'application_system_test_case'

class PollsVisitorTest < ApplicationSystemTestCase
  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
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
    assert_raise(ActiveRecord::RecordNotFound) { visit poll_path(poll) }
  end

  def assert_visit_poll(poll)
    visit poll_path(poll)

    assert_selector 'h1', text: 'Best actor'
    assert_selector 'p', text: 'Who is he?'
    assert_selector '.nominee', text: 'Bryan Cranston'

    assert_no_manage
    assert_no_poll_state_change

    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  def assert_no_manage
    within '.poll-title' do
      assert_selector 'a', text: 'Manage', count: 0
    end
  end

  def assert_no_poll_state_change
    within '.poll-state' do
      assert_selector 'a', count: 0
      assert_selector 'input', count: 0
    end
  end
end
