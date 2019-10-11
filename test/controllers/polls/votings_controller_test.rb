require 'test_helper'

class Polls::VotingsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :started_poll, :started_poll_token, :started_poll_nominee, :started_poll_redeemed_token,
              :published_poll, :published_poll_token, :published_poll_nominee

  setup do
    @started_poll, @published_poll = polls(:best_singer_started, :best_actor_published)
    @started_poll_token, @published_poll_token = tokens(:best_singer_token_not_redeemed, :best_actor_token_1)
    @started_poll_nominee, @published_poll_nominee = nominees(:best_singer_barbra_streisand, :best_actor_bill_murray)
    @started_poll_redeemed_token = tokens(:best_singer_token_redeemed)
  end

  test 'signed in user gets redirected on #new, with valid token' do
    sign_in_as(:julia_roberts)

    get poll_vote_path(started_poll, token_value: started_poll_token)
    follow_redirect!
    assert_response :success
  end

  test 'admin cannot post #create, with valid token' do
    sign_in_as(:julia_roberts)

    assert_no_changes -> { started_poll_token.redeemed? } do
      assert_raise(Pundit::NotAuthorizedError) do
        post poll_voting_path(started_poll),
             params: poll_voting_params(started_poll_token.value, started_poll_nominee.id)
        started_poll_token.reload
      end
    end
  end

  test 'guest can get #new with valid, not redeemed token' do
    sign_out

    assert_changes -> { started_poll_token.used? } do
      get poll_vote_path(started_poll, token_value: started_poll_token)
      started_poll_token.reload
    end
    assert_response :success
  end

  test 'guest can post #create with valid, not redeemed token' do
    sign_out

    assert_changes -> { started_poll_token.redeemed? }, to: true do
      post poll_voting_path(started_poll),
           params: poll_voting_params(started_poll_token.value, started_poll_nominee.id)
      started_poll_token.reload
    end
    follow_redirect!
    assert_response :success

    assert_equal 'Thank you for your vote!', flash[:notice]
  end

  test '#create with valid, not redeemed token, wrong nominee' do
    sign_out

    assert_no_changes -> { started_poll_token.redeemed? } do
      post poll_voting_path(started_poll),
           params: poll_voting_params(started_poll_token.value, published_poll_nominee.id)
      started_poll_token.reload
    end

    assert_response :success
  end

  test 'guest gets redirected to tokens#show with redeemed token' do
    sign_out

    get poll_vote_path(started_poll, token_value: started_poll_redeemed_token)
    follow_redirect!
    assert_response :success
  end

  test 'guest cannot post #create with redeemed token' do
    sign_out

    assert_no_changes -> { started_poll_redeemed_token.redeemed? } do
      assert_raise(Pundit::NotAuthorizedError) do
        post poll_voting_path(started_poll),
             params: poll_voting_params(started_poll_redeemed_token.value, started_poll_nominee.id)
        started_poll_redeemed_token.reload
      end
    end
  end

  test 'guest cannot get #new with invalid token' do
    sign_out

    assert_raise(ActiveRecord::RecordNotFound) do
      post poll_voting_path(started_poll),
           params: poll_voting_params('INVALID', started_poll_nominee.id)
    end
  end

  test 'guest is redirected on #new to poll if poll is not started' do
    assert_raise(ActiveRecord::RecordNotFound) do
      get poll_vote_path(polls(:best_actress_draft), token_value: 'not-relevant-for-this-test')
    end

    assert_raise(ActiveRecord::RecordNotFound) do
      get poll_vote_path(polls(:best_book_deleted), token_value: 'not-relevant-for-this-test')
    end

    get poll_vote_path(published_poll, token_value: 'BEST-ACTOR-TOKEN-1')
    follow_redirect!
    assert_response :success

    get poll_vote_path(polls(:best_movie_closed), token_value: 'BEST-MOVIE-TOKEN-1')
    follow_redirect!
    assert_response :success

    assert_raise(ActiveRecord::RecordNotFound) do
      get poll_vote_path(polls(:best_song_archived), token_value: 'BEST-SONG-TOKEN-1')
    end
  end

  test 'guest cannot post #create for an unstarted poll, with valid token' do
    sign_out

    assert_raise(Pundit::NotAuthorizedError) do
      post poll_voting_path(published_poll),
           params: poll_voting_params(published_poll_token.value, published_poll_nominee.id)
    end
  end

  private

  def poll_voting_params(token_value, nominee_id)
    {
      poll_voting: {
        token_value: token_value,
        nominee_id: nominee_id
      }
    }
  end
end
