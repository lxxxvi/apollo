require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test '#authentication_token_email' do
    email = UserMailer.with(user: users(:julia_roberts)).authentication_token_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 1, email.to.count
    assert_equal 'julia@apollo.test', email.to.first
    assert_equal 'Your Apollo authentication token', email.subject
    assert_equal read_fixture('authentication_token_email.html').join, email.body.to_s
  end
end
