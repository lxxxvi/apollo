require 'test_helper'

class PollsControllerTest < ActionDispatch::IntegrationTest
  attr_reader :draft_poll, :published_poll, :started_poll, :closed_poll, :archived_poll, :deleted_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
    sign_out
  end

  test '#get index' do
    get polls_path
    assert_response :success
  end

  test '#get show published, started, closed, archived' do
    [published_poll, started_poll, closed_poll, archived_poll].each do |poll|
      get poll_path(poll)
      assert_response :success
    end
  end

  test 'not #get show draft, deleted' do
    [draft_poll, deleted_poll].each do |poll|
      assert_raises(ActiveRecord::RecordNotFound) { get poll_path(poll) }
    end
  end

  test 'new poll' do
    get new_poll_path
    assert_response :success
  end

  test 'create poll' do
    assert_difference -> { User.count }, 1 do
      assert_difference -> { Poll.count }, 1 do
        post polls_path, params: {
          poll: {
            title: 'The poll name',
            email: 'email@apollo.test',
            description: 'A description'
          }
        }
      end
    end
    follow_redirect!
    assert_response :success
  end
end
