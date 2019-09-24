require 'application_system_test_case'

class PollsVoteTest < ApplicationSystemTestCase
  attr_reader :started_poll, :started_poll_token_unused

  setup do
    @started_poll = polls(:best_singer_started)
    @started_poll_token_unused = tokens(:best_singer_token_unused)
  end

  test 'guest votes for a started poll using valid token' do
    sign_out

    visit admin_poll_vote_path(started_poll, token_value: started_poll_token_unused.value)

    assert_selector 'h1', text: 'Cast your vote'

    click_on 'Cast vote'

    assert_selector '.errors', text: 'Please select a nominee'

    within('.nominees') do
      assert_selector "input[type='radio']"
      choose('Adele')
    end

    click_on 'Cast vote'

    assert_selector 'h1', text: 'Best singer'
  end

  test 'signed in user cannot vote' do
    sign_in_as(:julia_roberts)

    visit admin_poll_vote_path(started_poll, token_value: started_poll_token_unused.value)

    assert_selector 'h1', text: 'Best singer'
  end
end
