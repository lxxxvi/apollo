ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_in_as(user_fixture_name)
      user = users(user_fixture_name)
      get sign_in_path(user.authentication_token)
    end

    def sign_out
      get sign_out_path
    end

    # Pundit helpers
    def assert_permit(user, record, action)
      msg = "User #{user.inspect} should be permitted to #{action} #{record}, but isn't permitted"
      assert permit(user, record, action), msg
    end

    def refute_permit(user, record, action)
      msg = "User #{user.inspect} should NOT be permitted to #{action} #{record}, but is permitted"
      assert_not permit(user, record, action), msg
    end

    def permit(user, record, action)
      cls = self.class.to_s.gsub(/Test/, '')
      cls.constantize.new(user, record).public_send(action)
    end

    # e.g. to_date_time_params(:foo, 2010, 2, 3)
    # => { 'foo(1i)': '2010', 'foo(2i)': '2', 'foo(3i)': '3'}
    def to_date_time_params(attribute_name, *date_time_fragments)
      (1..6).map { |n| "#{attribute_name}(#{n}i)" }
            .zip(date_time_fragments.map(&:to_s))
            .keep_if { |_k, v| v.present? }
            .to_h
    end
  end
end
