require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'visiting home' do
    visit root_path

    assert_selector 'h1', text: 'All polls'

    new_poll_button = find('a[href$="polls/new"]')
    assert_equal 'New poll', new_poll_button['aria-label']
    assert_equal 'New poll', new_poll_button['title']
  end
end
