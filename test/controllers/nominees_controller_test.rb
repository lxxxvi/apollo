require 'test_helper'

class NomineesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'new nominee' do
    get new_poll_nominee_path(best_actor_poll)
    assert_response :success
  end

  test 'create nominee' do
    assert_difference -> { Nominee.count }, 1 do
      post poll_nominees_path(best_actor_poll), params: {
        nominee: {
          name: 'John Malkovich',
          description: 'Being John Malkovich'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'edit nominee' do
    nominee = nominees(:best_actor_bill_murray)
    get edit_poll_nominee_path(best_actor_poll, nominee)
    assert_response :success
  end

  test 'update nominee' do
    nominee = nominees(:best_actor_bill_murray)

    assert_changes -> { nominee.name } do
      assert_changes -> { nominee.description } do
        patch poll_nominee_path(best_actor_poll, nominee), params: {
          nominee: {
            name: 'Bill Ghost-Bustin Murray',
            description: 'He aint afraid of no ghost'
          }
        }
        nominee.reload
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'delete nominee' do
    skip
  end
end
