require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'visiting home' do
    visit root_path

    assert_selector 'h1', text: 'Home'
    assert_selector 'a.ui.primary.button[href$="polls/new"]', text: 'Create poll'
  end
end
