require 'application_system_test_case'

class TokenTest < ApplicationSystemTestCase
  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'create token' do
    visit poll_path(@best_actor_poll)

    assert_selector 'h2', text: 'Tokens'
    assert_equal 1, token_items.count

    add_token_button = find("form[action$='/tokens'] button[type='submit']")

    assert_equal 'Add token', add_token_button['aria-label']
    assert_equal 'Add token', add_token_button['title']

    assert_difference -> { token_items.count }, 1 do
      add_token_button.click
    end
  end

  private

  def token_items
    find_all('.tokens .token')
  end
end
