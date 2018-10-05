require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'visiting home' do
    visit root_path

    assert_selector 'h1', text: 'All polls'
    assert_selector 'a[href$="polls/new"]', text: 'New poll'
  end
end
