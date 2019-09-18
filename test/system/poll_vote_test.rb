require 'application_system_test_case'

class PollsVoteTest < ApplicationSystemTestCase
  attr_reader :started_poll

  setup do
    @started_poll = polls(:best_singer_started)
  end

  test 'guest votes for a started poll using valid token' do
    sign_out

    token = started_poll.tokens.first

    visit poll_vote_path(started_poll, token_value: token.value)

    assert_selector 'h1', text: 'Cast your vote'

    click_on 'Cast vote'

    assert_selector '.errors', text: 'Please select a nominee'

    within('.nominees') do
      assert_selector "input[type='radio'][aria-label]"
      choose('Adele')
    end

    click_on 'Cast vote'

    assert_selector 'h1', text: 'Best singer'
  end

  test 'signed in user cannot vote' do
    sign_in_as(:julia_roberts)

    token = started_poll.tokens.first

    visit poll_vote_path(started_poll, token_value: token.value)

    assert_selector 'h1', text: 'Best singer'
    assert_text 'You are not allowed to take part in the poll when signed in.'
  end
end
