require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test 'creates a value' do
    poll = polls(:best_actor)
    token = Token.create!(poll: poll)

    assert_match(/[[:alnum:]]+/, token.reload.value)
  end

  test '#to_param' do
    token = tokens(:best_actor_token_1)
    assert_not_equal token.id, token.to_param.to_i, '#id should not be used as param'
  end
end
