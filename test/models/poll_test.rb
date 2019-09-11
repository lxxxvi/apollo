require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test 'generates custom_id' do
    new_poll = Poll.create(title: 'Apollo', user: users(:julia_roberts))

    assert_match(/[[:alnum:]]{12}/, new_poll.custom_id)
  end

  test '#to_param' do
    poll = polls(:best_actor_published)
    assert_not_equal poll.id, poll.to_param.to_i, '#id should not be used as param'
  end

  test '.of_user' do
    julia = users(:julia_roberts)
    tina = users(:tina_fey)
    poll = polls(:best_actor_published)

    assert_difference -> { Poll.of_user(julia).count }, -1 do
      poll.update(user: tina)
    end
  end
end
