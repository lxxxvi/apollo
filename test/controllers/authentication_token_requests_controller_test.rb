require 'test_helper'

class AuthenticationTokenRequestsControllerTest < ActionDispatch::IntegrationTest
  test 'get new' do
    get request_token_path
    assert_response :success
  end

  test 'user requests a new token with valid email address' do
    user = users(:julia_roberts)
    timestamp = DateTime.new(2020, 1, 1, 12, 0, 0)

    travel_to timestamp do
      assert_changes -> { user.authentication_token } do
        assert_changes -> { user.authentication_token_expires_at } do
          assert_emails 1 do
            post authentication_token_requests_path, params: {
              authentication_token_request: {
                email: 'julia@apollo.test'
              }
            }
            assert_response :success
            user.reload
          end
        end
      end
    end
  end

  test 'user requests a new token with an invalid email address' do
    assert_emails 0 do
      post authentication_token_requests_path, params: {
        authentication_token_request: {
          email: 'does-not-exist@apollo.test'
        }
      }
      assert_response :success
    end
  end
end
