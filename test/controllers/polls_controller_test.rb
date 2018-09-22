require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  test 'show poll' do
    poll = polls(:best_actor)
    get poll_path(poll)
    assert_response :success
  end

  test 'new poll' do
    get new_poll_path
    assert_response :success
  end

  test 'create poll' do
    assert_difference -> { Poll.count }, 1 do
      post polls_path, params: {
        poll: {
          title: 'The poll name',
          email: 'email@apollo.test',
          description: 'A description'
        }
      }
    end
    follow_redirect!
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
