require 'test_helper'

class TokenValuesGeneratorTest < ActiveSupport::TestCase
  test 'generates 1 value' do
    assert_equal 1, TokenValuesGenerator.generate_values.count
  end

  test 'generates n values' do
    assert_equal 10, TokenValuesGenerator.generate_values(10).count
  end
end
