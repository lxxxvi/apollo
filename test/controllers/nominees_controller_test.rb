require 'test_helper'

class NomineesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :best_actor_poll

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  test 'new nominee' do
    get new_poll_nominee_path(best_actor_poll)
    assert_response :success
  end

  test 'create nominee' do
    skip
  end

  test 'edit nominee' do
    skip
  end

  test 'update nominee' do
    skip
  end

  test 'delete nominee' do
    skip
  end
end
