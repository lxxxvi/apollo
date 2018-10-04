require 'test_helper'

class NomineeTest < ActiveSupport::TestCase
  test 'creates a custom id' do
    poll = polls(:best_actor)
    nominee = Nominee.create!(poll: poll,
                              name: 'John Malkovich',
                              description: 'Being John Malkovich')

    assert_match /[[:alnum:]]+/, nominee.reload.custom_id
  end

  test '#to_param' do
    nominee = nominees(:best_actor_bill_murray)
    assert_not_equal nominee.id, nominee.to_param, '#id should not be used as param'
  end
end
