require 'test_helper'

class TokenFormTest < ActiveSupport::TestCase
  attr_reader :poll

  setup do
    @poll = polls(:best_actor)
  end

  test 'invalid minimum amount' do
    assert_not TokenForm.new(poll, amount: 0).valid?
  end

  test 'invalid maximum amount' do
    form = TokenForm.new(poll, amount: 1_001)
    assert_not form.valid?

    form.errors.to_a.tap do |errors|
      assert_includes errors, 'Amount must be less than or equal to 1000'
      assert_includes errors, 'Total number of tokens may not exceed 1000'
    end
  end

  test 'valid minimum amount' do
    assert TokenForm.new(poll, amount: 1).valid?
  end

  test 'valid maximum amount' do
    poll.tokens.destroy_all
    assert TokenForm.new(poll, amount: 1_000).valid?
  end

  test '#save' do
    assert_difference -> { poll.tokens.count }, 3 do
      TokenForm.new(poll, amount: 3).save
    end
  end
end
