require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'authentication_token is set after initialize' do
    user = User.new

    assert_match(/[[:alnum:]]+/, user.authentication_token)
    assert_not user.authentication_token_expires_at.nil?
  end

  test 'refresh_authentication_token!' do
    user = users(:julia_roberts)
    timestamp = DateTime.new(2020, 1, 1, 12, 0, 0)

    travel_to timestamp do
      assert_changes -> { user.authentication_token } do
        assert_changes -> { user.authentication_token_expires_at.to_s },
                       to: '2020-01-08 12:00:00 UTC' do
          user.refresh_authentication_token!
        end
      end
    end
  end

  test '.with_valid_authentication_tokens' do
    user = users(:julia_roberts)

    before_count = with_valid_authentication_tokens_count_at(user.authentication_token_expires_at)
    after_count = with_valid_authentication_tokens_count_at(user.authentication_token_expires_at + 1.second)

    assert before_count > after_count, 'Count should decrease 1 second later'
  end

  private

  def with_valid_authentication_tokens_count_at(time)
    travel_to(time) { User.with_valid_authentication_tokens.count }
  end
end
