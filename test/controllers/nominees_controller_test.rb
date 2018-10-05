require 'test_helper'

class NomineesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll, :best_actor_bill_murray

  setup do
    @best_actor_poll = polls(:best_actor)
    @best_actor_bill_murray = nominees(:best_actor_bill_murray)
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
    get edit_poll_nominee_path(best_actor_poll, best_actor_bill_murray)
    assert_response :success
  end

  test 'update nominee' do
    assert_changes -> { best_actor_bill_murray.name } do
      assert_changes -> { best_actor_bill_murray.description } do
        patch poll_nominee_path(best_actor_poll, best_actor_bill_murray), params: {
          nominee: {
            name: 'Bill Ghost-Bustin Murray',
            description: 'He aint afraid of no ghost'
          }
        }
        best_actor_bill_murray.reload
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'delete nominee' do
    assert_difference -> { Nominee.count }, -1 do
      delete poll_nominee_path(best_actor_poll, best_actor_bill_murray)
    end
    follow_redirect!
    assert_response :success
  end
end
