require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test '#show' do
    get home_path
    assert_response :success

    get root_path
    assert_response :success
  end
end
