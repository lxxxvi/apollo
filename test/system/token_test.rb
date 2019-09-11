require 'application_system_test_case'

class TokenTest < ApplicationSystemTestCase
  NEW_TOKENS_TEXT = 'Add tokens'.freeze
  DELETE_TOKEN_TEXT = 'Delete'.freeze

  setup do
    @poll = polls(:best_actor_published)
  end

  test 'create tokens' do
    sign_in_as(:julia_roberts)

    visit poll_path(@poll)

    assert_selector 'h2', text: 'Tokens'
    assert_equal 1, token_items.count

    assert_difference -> { token_items.count }, 3 do
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
    end
  end

  test 'create too many tokens' do
    sign_in_as(:julia_roberts)

    visit new_poll_token_path(@poll)

    assert_selector 'h1', text: NEW_TOKENS_TEXT

    fill_in 'How many tokens would you like to add?', with: '1000'
    find("input[type='submit']").click

    assert_selector 'h1', text: 'Add tokens'
    assert_selector 'input[aria-invalid="true"]', count: 1
  end

  test 'delete token' do
    sign_in_as(:julia_roberts)

    visit poll_path(@poll)

    assert_difference -> { token_items.count }, -1 do
      within '.token:first-child' do
        click_with_delete(delete_token_link)
      end
    end
  end

  test 'guest does not see "Add token" button' do
    sign_out
    visit poll_path(@poll)
    assert_raises(Capybara::ElementNotFound) { add_tokens_link }
  end

  test 'guest does not see token action buttons' do
    sign_out
    visit poll_path(@poll)
    assert_raises(Capybara::ElementNotFound) { delete_token_link }
  end

  private

  def token_items
    find_all('.tokens li.token')
  end

  def add_tokens_link
    find 'a', text: NEW_TOKENS_TEXT
  end

  def delete_token_link
    find 'a', text: DELETE_TOKEN_TEXT
  end
end
