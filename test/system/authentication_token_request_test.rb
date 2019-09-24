require 'application_system_test_case'

class RequestTokenTest < ApplicationSystemTestCase
  test 'user requests a new authentication token' do
    visit root_path

    click_on 'Sign in'
    assert_selector 'h1', text: 'Request a new token'
    click_on 'Cancel'
    assert_selector 'h1', text: 'All polls'
    click_on 'Sign in'
    assert_selector 'h1', text: 'Request a new token'
    fill_in 'Email', with: 'julia@apollo.test'

    assert_emails 1 do
      click_on 'Send me a new token'
    end

    assert_selector 'h1', text: 'Request a new token'
    assert_selector '.notice', text: 'Please find the token in the email that we have just sent you'
  end
end
