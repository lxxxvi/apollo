require 'application_system_test_case'

class NomineesTest < ApplicationSystemTestCase
  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'visiting the nominee form' do
    visit poll_path(@best_actor_poll)

    assert_selector('a', text: 'Add nominee')
    click_on('Add nominee')

    assert_selector('h1', text: 'Add nominee')
    assert_selector('form.new_nominee') do
      assert_selector('input[type="submit"]')
      assert_selector('a.ui.button', text: 'Cancel')
    end

    find_label_and_input_for('nominee_name')
    find_label_and_textarea_for('nominee_description')
  end

  test 'submit new empty form' do
    skip
  end

  test 'submit new complete form' do
    skip
  end

  test 'submit edit form' do
    skip
  end

  test 'delete nominee' do
    skip
  end
end
