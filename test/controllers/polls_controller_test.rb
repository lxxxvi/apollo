require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :poll

  setup do
    @poll = polls(:best_actor_published)
  end

  test 'show poll' do
    get poll_path(poll)
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
    sign_in_as(:julia_roberts)

    get edit_poll_path(poll)
    assert_response :success
  end

  test 'should post update' do
    sign_in_as(:julia_roberts)

    assert_changes -> { poll.reload.updated_at } do
      patch poll_path(poll), params: {
        poll: {
          title: 'Best Actress',
          description: 'Another description'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions' do
    sign_in_as(:tina_fey)

    assert_raise(ActiveRecord::RecordNotFound) { get edit_poll_path(poll) }
    assert_raise(ActiveRecord::RecordNotFound) { patch poll_path(poll) }
  end
end
