require 'test_helper'

class Admin::PollStateChangeFormTest < ActiveSupport::TestCase
  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
    @deleted_poll = polls(:best_book_deleted)
  end

  test 'draft poll' do
    assert Admin::PollStateChangeForm.new(@draft_poll, next_state: :published).valid?
    assert_not Admin::PollStateChangeForm.new(@draft_poll, next_state: :started).valid?
  end

  test 'published poll' do
    assert Admin::PollStateChangeForm.new(@published_poll, next_state: :started).valid?
    assert_not Admin::PollStateChangeForm.new(@published_poll, next_state: :closed).valid?
  end

  test 'started poll' do
    assert Admin::PollStateChangeForm.new(@started_poll, next_state: :closed).valid?
    assert_not Admin::PollStateChangeForm.new(@started_poll, next_state: :archived).valid?
  end

  test 'closed poll' do
    assert Admin::PollStateChangeForm.new(@closed_poll, next_state: :archived).valid?
  end
end
