require 'application_system_test_case'

class TokenTest < ApplicationSystemTestCase
  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'create tokens' do
    visit poll_path(@best_actor_poll)

    assert_selector 'h2', text: 'Tokens'
    assert_equal 1, token_items.count

    assert_difference -> { token_items.count }, 3 do
      assert_selector 'a', text: 'Add tokens', &:click
      assert_selector 'a', text: 'Cancel', &:click
      assert_selector 'a', text: 'Add tokens', &:click
      assert_selector 'h1', text: 'Add tokens'

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
    visit new_poll_token_path(@best_actor_poll)

    assert_selector 'h1', text: 'Add tokens'

    fill_in 'How many tokens would you like to add?', with: '1000'
    find("input[type='submit']").click

    assert_selector 'h1', text: 'Add tokens'
    assert_selector '.error-messages', text: 'Total number of tokens may not exceed 1000'
  end

  test 'delete token' do
    visit poll_path(@best_actor_poll)

    delete_token_link = find(".tokens a[data-method='delete']", match: :first)

    assert_equal 'Delete', delete_token_link.text
    assert_equal 'Delete token', delete_token_link['aria-label']
    assert_equal 'Delete token', delete_token_link['title']

    assert_difference -> { token_items.count }, -1 do
      click_with_delete(delete_token_link)
    end
  end

  private

  def token_items
    find_all('.tokens li.token')
  end
end
