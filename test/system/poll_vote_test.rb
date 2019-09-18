require 'application_system_test_case'

class PollsVoteTest < ApplicationSystemTestCase
  attr_reader :started_poll

  setup do
    @started_poll = polls(:best_singer_started)
  end

  test 'guest votes for a started poll using valid token' do
    sign_out

    token = started_poll.tokens.first

    visit vote_poll_path(started_poll, token: token.value)

    assert_selector 'h1', text: 'Cast your vote'

    assert_selector '.nominees'

    click_on 'Vote for Adele'

    within('.selected-nominee') do
      assert_selector 'h3', text: 'Adele'
      assert_text 'You voted for Adele'
    end

    click_on 'Vote for Barbra Streisand'

    within('.selected-nominee') do
      assert_selector 'h3', text: 'Barbra Streisand'
      assert_text 'You voted for Barbra Streisand'
    end
  end

  test 'signed in user cannot vote' do
    sign_in_as(:julia_roberts)

    token = started_poll.tokens.first

    visit poll_vote_path(started_poll, token: token.value)

    assert_selector 'h1', text: 'Best singer'
    assert_text 'You are not allowed to take part in the poll when signed in.'
  end
end
