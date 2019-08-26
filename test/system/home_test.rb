require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'visiting home' do
    visit root_path

    assert_selector 'h1', text: 'All polls'

    assert_selector 'a', text: 'New poll' do |new_poll_link|
      assert_equal 'New poll', new_poll_link['aria-label']
      assert_equal 'New poll', new_poll_link['title']
    end
  end
end
