require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test 'generates custom_id' do
    new_poll = Poll.create(title: 'Apollo', user: users(:julia_roberts))

    assert_match(/[[:alnum:]]{12}/, new_poll.custom_id)
  end

  test '#to_param' do
    poll = polls(:best_actor)
    assert_not_equal poll.id, poll.to_param.to_i, '#id should not be used as param'
  end

  test 'initial state' do
    assert Poll.new.draft?
  end

  test '#publish!' do
    poll = Poll.new(title: 'Apollo', user: users(:julia_roberts))
    poll.save!

    assert_changes 'poll.state', from: 'draft', to: 'published' do
      assert_changes 'poll.published_at', from: nil do
        poll.publish!
      end
    end
  end
end
