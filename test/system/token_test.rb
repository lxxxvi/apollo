require 'application_system_test_case'

class TokenTest < ApplicationSystemTestCase
  NEW_TOKENS_TEXT = 'Add tokens'.freeze
  DELETE_TOKEN_TEXT = 'Delete'.freeze

  setup do
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
  end

  test 'create tokens' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(@published_poll)

    click_on 'Manage'

    within('.tokens-section') do
      assert_selector 'h2', text: 'Tokens'
      assert_text 'This poll has 1 token.'
    end

    add_tokens_link.click
    assert_selector 'a', text: 'Cancel', &:click
    add_tokens_link.click
    assert_selector 'h1', text: NEW_TOKENS_TEXT

    find_label_and_input_for('poll_token_amount')
    fill_in 'How many tokens would you like to add?', with: '3'

    within 'form#new_poll_token' do
      submit_button = find("input[type='submit']")
      assert_equal 'Add tokens', submit_button.value
      submit_button.click
    end

    assert_selector 'h1', text: 'Manage poll'

    within('.tokens-section') do
      assert_selector 'h2', text: 'Tokens'
      assert_text 'This poll has 4 tokens.'
    end
  end

  test 'create too many tokens' do
    sign_in_as(:julia_roberts)

    visit new_admin_poll_token_path(@published_poll)

    assert_selector 'h1', text: NEW_TOKENS_TEXT

    fill_in 'How many tokens would you like to add?', with: '1000'
    find("input[type='submit']").click

    assert_selector 'h1', text: 'Add tokens'
    assert_selector 'input[aria-invalid="true"]', count: 1
  end

  test 'admin cannot add tokens if poll has started' do
    sign_in_as(:julia_roberts)

    visit manage_admin_poll_path(@started_poll)

    within('.tokens-section') do
      assert_selector 'a', text: 'Add tokens', count: 0
    end
  end

  private

  def add_tokens_link
    find 'a', text: NEW_TOKENS_TEXT
  end

  def delete_token_link
    find 'a', text: DELETE_TOKEN_TEXT
  end
end
