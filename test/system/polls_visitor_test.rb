require 'application_system_test_case'

class PollsVisitorTest < ApplicationSystemTestCase
  setup do
    @poll = polls(:best_actor_published)
  end

  test 'non-admin cannot visit a listed poll' do
    sign_in_as(:tina_fey)
    assert_no_visit_poll @poll
  end

  test 'guest visits a listed poll' do
    sign_out
    assert_visit_poll @poll
  end

  test 'guest cannot visit an unlisted poll' do
    sign_out
    @poll.update(published_at: nil)
    assert_no_visit_poll @poll
  end

  private

  def assert_no_visit_poll(poll)
    assert_raise(ActiveRecord::RecordNotFound) { visit poll_path(poll) }
  end

  def assert_visit_poll(poll)
    visit poll_path(poll)

    assert_selector 'h1', text: 'Best actor'
    assert_selector 'p', text: 'Who is he?'
    assert_selector 'body', text: 'Bryan Cranston'
    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'

    assert_selector '.poll-actions a', count: 0
    assert_selector '.poll-state-actions a', count: 0
  end
end
