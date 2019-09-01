require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'show poll' do
    get poll_path(best_actor_poll)
    assert_response :success
  end

  test 'new poll' do
    get new_poll_path
    assert_response :success
  end

  test 'create poll' do
    assert_difference -> { User.count }, 1 do
      assert_difference -> { Poll.count }, 1 do
        post polls_path, params: {
          poll: {
            title: 'The poll name',
            email: 'email@apollo.test',
            description: 'A description'
          }
        }
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'should get edit' do
    get edit_poll_path(best_actor_poll)
    assert_response :success
  end

  test 'should post update' do
    assert_changes -> { best_actor_poll.reload.updated_at } do
      patch poll_path(best_actor_poll), params: {
        poll: {
          title: 'Best Actress',
          description: 'Another description'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'should get delete' do
    assert_difference -> { Poll.count }, -1 do
      delete poll_path(best_actor_poll)
      follow_redirect!
      assert_response :success
    end
  end
end
