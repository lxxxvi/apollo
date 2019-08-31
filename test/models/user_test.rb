require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'authentication_token is set after initialize' do
    user = User.new

    assert_match(/[[:alnum:]]+/, user.authentication_token)
    assert_not user.authentication_token_expires_at.nil?
  end
end
