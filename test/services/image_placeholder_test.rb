require 'test_helper'

class ImagePlaceholderTest < ActiveSupport::TestCase
  test 'generates image placeholder' do
    assert_operator ImagePlaceholder.base64.size, :>, 50
  end
end
