require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_poll_path
    assert_response :success
  end

  test 'should post create' do
    post polls_path
    assert_response :success
  end

  test 'should get edit' do
    skip
    get edit_poll_path
    assert_response :success
  end

  test 'should post update' do
    skip
    patch poll_path(nil)
    assert_response :success
  end

  test 'should get delete' do
    skip
    delete destroy_poll_path(nil)
    assert_response :success
  end
end
