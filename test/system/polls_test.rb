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

  test 'submit empty poll form' do
    visit new_poll_path

    within('form#new_poll') do
      click_on('Create Poll')
    end

    assert_selector 'h1', text: 'New poll'

    assert_selector('form#new_poll') do
      assert_equal 2, all('input[aria-invalid="true"]').count
    end
  end

  test 'submit complete poll form' do
    visit new_poll_path

    within('form#new_poll') do
      fill_in('Title', with: 'Best singer')
      fill_in('Email', with: 'best-singer@apollo.test')
      fill_in('Description', with: 'Lorem ipsum')
      click_on('Create Poll')
    end

    assert_selector 'h1', text: 'Best singer'
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