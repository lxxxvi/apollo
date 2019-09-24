require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test '#home_path' do
    get root_path
    assert_response :success
  end

  test '#root_path' do
    get root_path
    assert_response :success
  end
end
