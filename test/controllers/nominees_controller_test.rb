require 'test_helper'

class NomineesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :poll, :nominee

  setup do
    @poll = polls(:best_actor_published)
    @nominee = nominees(:best_actor_bill_murray)
  end

  test 'new nominee' do
    sign_in_as(:julia_roberts)

    get new_poll_nominee_path(poll)
    assert_response :success
  end

  test 'create nominee' do
    sign_in_as(:julia_roberts)

    assert_difference -> { Nominee.count }, 1 do
      post poll_nominees_path(poll), params: {
        nominee: {
          name: 'John Malkovich',
          description: 'Being John Malkovich'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'edit nominee' do
    sign_in_as(:julia_roberts)

    get edit_poll_nominee_path(poll, nominee)
    assert_response :success
  end

  test 'update nominee' do
    sign_in_as(:julia_roberts)

    assert_changes -> { nominee.name } do
      assert_changes -> { nominee.description } do
        patch poll_nominee_path(poll, nominee), params: {
          nominee: {
            name: 'Bill Ghost-Bustin Murray',
            description: 'He aint afraid of no ghost'
          }
        }
        nominee.reload
      end
    end
    follow_redirect!
    assert_response :success
  end

  test 'delete nominee' do
    sign_in_as(:julia_roberts)

    assert_difference -> { Nominee.count }, -1 do
      delete poll_nominee_path(poll, nominee)
    end
    follow_redirect!
    assert_response :success
  end

  test 'unauthorized actions' do
    sign_in_as(:tina_fey)

    assert_raise(Pundit::NotAuthorizedError) { get new_poll_nominee_path(poll) }
    assert_raise(Pundit::NotAuthorizedError) { post poll_nominees_path(poll) }
    assert_raise(Pundit::NotAuthorizedError) { get edit_poll_nominee_path(poll, nominee) }
    assert_raise(Pundit::NotAuthorizedError) { patch poll_nominee_path(poll, nominee) }
    assert_raise(Pundit::NotAuthorizedError) { delete poll_nominee_path(poll, nominee) }
  end
end
