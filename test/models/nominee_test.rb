require 'test_helper'

class NomineeTest < ActiveSupport::TestCase
  test 'initializes an image placeholder' do
    assert_not_nil Nominee.new.image_placeholder
  end

  test 'creates a custom id' do
    poll = polls(:best_actor_published)
    nominee = Nominee.create!(poll: poll,
                              name: 'John Malkovich',
                              description: 'Being John Malkovich')

    assert_match(/[[:alnum:]]+/, nominee.reload.custom_id)
  end

  test '#to_param' do
    nominee = nominees(:best_actor_bill_murray)
    assert_not_equal nominee.id, nominee.to_param.to_i, '#id should not be used as param'
  end

  test 'uniqueness of nominee name' do
    nominee = nominees(:best_actor_bill_murray)
    new_nominee = nominee.dup
    assert_not new_nominee.valid?

    new_nominee.errors.full_messages.tap do |full_messages|
      assert_includes full_messages, 'Name has already been taken'
      assert_includes full_messages, 'Custom has already been taken'
    end
  end
end
