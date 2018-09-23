require 'application_system_test_case'

class PollsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit new_poll_path

    assert_selector('h1', text: 'New poll')
    assert_selector('form#new_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a.ui.button', text: 'Cancel')
    end
    find_label_and_input_for('poll_title')
    find_label_and_input_for('poll_email')
    find_label_and_textarea_for('poll_description')
  end

  private

  def find_label_and_input_for(html_id)
    find_label_for html_id
    assert_selector "input##{html_id}"
  end

  def find_label_and_textarea_for(html_id)
    find_label_for html_id
    assert_selector "textarea##{html_id}"
  end

  def find_label_for(html_id)
    assert_selector "label[for='#{html_id}']"
  end
end
