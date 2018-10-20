require 'test_helper'

class TokensControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'does not get new token' do
    assert_raise NoMethodError do
      get new_poll_token_path(best_actor_poll)
    end
  end

  test 'create token' do
    assert_difference -> { best_actor_poll.tokens.count }, 1 do
      post poll_tokens_path(best_actor_poll)
      best_actor_poll.reload
    end
    follow_redirect!
    assert_response :success
  end
end
