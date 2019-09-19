require 'test_helper'

class PollVotingFormTest < ActiveSupport::TestCase
  attr_reader :token, :nominee

  setup do
    @token = tokens(:best_singer_token_unused)
    @nominee = nominees(:best_singer_adele)
  end

  test 'valid form' do
    PollVotingForm.new(token, nominee_id: nominee.id).tap do |form|
      assert form.valid?
      assert form.save!
    end
  end

  test 'invalid form' do
    PollVotingForm.new(token, nominee_id: 0).tap do |form|
      assert_not form.valid?
      assert_not form.save!
    end
  end
end
