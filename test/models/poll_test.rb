require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test 'generates custom_id' do
    new_poll = Poll.create(title: 'Apollo', email: 'email@apollo.test')

    assert_match(/[[:alnum:]]{12}/, new_poll.custom_id)
  end

  test '#to_param' do
    poll = polls(:best_actor)
    assert_not_equal poll.id, poll.to_param, '#id should not be used as param'
  end
end
