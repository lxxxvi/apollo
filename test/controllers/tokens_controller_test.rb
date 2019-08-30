require 'test_helper'

class TokensControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll, :best_actor_token_one

  setup do
    @best_actor_poll = polls(:best_actor)
    @best_actor_token_one = tokens(:best_actor_token_1)
  end

  test 'get new token' do
    get new_poll_token_path(best_actor_poll)
    assert_response :success
  end

  test 'create token' do
    assert_difference -> { best_actor_poll.tokens.count }, 1 do
      post poll_tokens_path(best_actor_poll), params: {
        poll_token: { amount: 1 }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'delete token' do
    assert_difference -> { best_actor_poll.tokens.count }, -1 do
      delete poll_token_path(best_actor_poll, best_actor_token_one)
    end
    follow_redirect!
    assert_response :success
  end
end
