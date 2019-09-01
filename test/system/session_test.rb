require 'application_system_test_case'

class SessionTest < ApplicationSystemTestCase
  test 'user signs in with valid authentication token' do
    sign_in_as :julia_roberts

    assert_selector 'h1', text: 'All polls'
    assert_selector '.notice', text: 'Successfully signed in.'
  end

  test 'user cannot sign in with invalid authentication token' do
    visit sign_in_url('WRONGTOKEN')

    assert_selector 'h1', text: 'Request a new token'
    assert_selector '.notice', text: 'Invalid authentication token.'
  end

  test 'sign out is displayed' do
    visit home_path

    assert_selector 'a', text: 'Sign in'
    assert_selector 'a', text: 'Sign out', count: 0

    sign_in_as :julia_roberts

    assert_selector 'a', text: 'Sign in', count: 0
    assert_selector 'a', text: 'Sign out'
  end
end
