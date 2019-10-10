require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test 'creates a value' do
    poll = polls(:best_actor_published)
    token = Token.create!(poll: poll)

    assert_match(/[[:alnum:]]+/, token.reload.value)
  end

  test '#to_param' do
    token = tokens(:best_actor_token_1)
    assert_not_equal token.id, token.to_param.to_i, '#id should not be used as param'
  end

  test '#mark_first_visit! unused' do
    token = tokens(:best_actor_token_1)

    assert_changes -> { token.used? }, to: true do
      assert_changes -> { token.first_visited_at }, from: nil do
        token.mark_first_visit!
        token.reload
      end
    end
  end

  test '#mark_first_visit! used' do
    token = tokens(:best_actor_token_1)

    token.update!(first_visited_at: '2000-01-01 01:01:01')

    travel_to '2020-02-02 02:02:02' do
      assert_no_changes -> { token.first_visited_at } do
        token.mark_first_visit!
        token.reload
      end
    end
  end
end
