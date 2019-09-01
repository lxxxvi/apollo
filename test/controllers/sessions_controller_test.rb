require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'user signs in using valid authentication token' do
    user = users(:julia_roberts)

    travel_to user.authentication_token_expires_at do
      get sign_in_url(authentication_token: user.authentication_token)
      follow_redirect!
      assert_response :success
    end

    assert_equal 'Successfully signed in.', flash[:notice]
  end

  test 'user cant sign in using expired authentication token' do
    user = users(:julia_roberts)

    travel_to user.authentication_token_expires_at.plus_with_duration(1.second) do
      get sign_in_url(authentication_token: user.authentication_token)
      follow_redirect!
      assert_response :success
    end

    assert_equal 'Invalid authentication token.', flash[:notice]
  end

  test 'user cant sign in using invalid authentication token' do
    user = users(:julia_roberts)

    travel_to user.authentication_token_expires_at do
      get sign_in_url(authentication_token: 'WRONGTOKEN')
      follow_redirect!
      assert_response :success
    end

    assert_equal 'Invalid authentication token.', flash[:notice]
  end

  test 'delete sign_out' do
    sign_in_as(:julia_roberts)

    assert_changes 'session[:user_id]', to: nil do
      get sign_out_path
      follow_redirect!
      assert_response :success
    end
  end
end
