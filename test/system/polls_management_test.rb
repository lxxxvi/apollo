require 'application_system_test_case'

class PollsManagementTest < ApplicationSystemTestCase
  attr_reader :draft_poll, :published_poll, :started_poll, :closed_poll, :archived_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
  end

  test 'create a new poll' do
    sign_out
    visit new_admin_poll_path

    assert_selector 'h1', text: 'New poll'
    within('form.new_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a', text: 'Cancel')

      find_label_and_input_for('poll_title')
      find_label_and_input_for('poll_email')
      find_label_and_textarea_for('poll_description')
    end

    click_on('Create Poll')
    assert_selector 'h1', text: 'New poll'

    assert_selector('form.new_poll') do
      assert_equal 2, all('input[aria-invalid="true"]').count
    end

    within('form.new_poll') do
      fill_in('Title', with: 'Best singer')
      fill_in('Email', with: 'best-singer@apollo.test')
      fill_in('Description', with: 'Lorem ipsum')
      click_on('Create Poll')
    end

    assert_selector 'h1', text: 'Best singer'
  end

  test 'signed in user sees only own polls' do
    user = users(:julia_roberts)
    sign_in_as(user)

    assert_selector '.polls', count: 1
    assert_equal Poll.of_user(user).without_deleted.count, find_all('.poll').count

    sign_out

    user = users(:tina_fey)
    sign_in_as(user)

    assert_selector '.polls', count: 1
    assert_equal Poll.of_user(user).without_deleted.count, find_all('.poll').count
  end

  # show

  test 'admin visits an drafted poll' do
    sign_in_as(:julia_roberts)

    visit admin_polls_path

    click_on draft_poll.title

    assert_selector 'h1', text: 'Best actress'
    assert_selector 'p', text: 'Who is she?'
    assert_selector 'body', text: 'Julia Roberts'
    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  test 'admin visits admin area of a poll' do
    assert false, 'implement me'
  end

  # edit

  test 'admin edits an unstarted poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(published_poll)

    click_on 'Manage'

    within('.information-section form') do
      fill_in('Title', with: 'Best actress')
      fill_in('Description', with: 'Who is she?')
      click_on('Update Poll')
    end

    assert_selector 'h1', text: 'Manage poll'
  end

  test 'admin cannot edit poll once started' do
    sign_in_as(:julia_roberts)

    [started_poll, closed_poll, archived_poll].each do |poll|
      visit admin_poll_path(poll)

      within('.information-section form') do
        assert_selector "input[type='submit']", count: 0

        input_elements = find_all('input, textarea')
        disabled_elements = find_all("[disabled='disabled']")

        assert_equal input_elements.count, disabled_elements.count, 'All input elements should be disabled'
      end

      within('.nominees-section') do
        assert_selector 'a', count: 0
      end

      within('.tokens-section') do
        assert_selector 'a', count: 0
      end
    end
  end

  test 'admin cannot publish a poll if the email is not verified' do
    sign_in_as(:julia_roberts)

    user = users(:julia_roberts)
    user.update(email_verified_at: nil)

    visit admin_poll_path(draft_poll)

    assert_selector '.poll-state', text: 'draft'
    assert_text 'In order to publish this poll you need to verify your email first.'
    assert_selector ".poll-state-actions input[value='Publish poll']", count: 0
  end

  test 'admin publishes a drafted a poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(draft_poll)
    assert_selector '.poll-state', text: 'draft'

    click_on 'Publish poll'
    assert_selector '.poll-state', text: 'published'
  end

  test 'admin starts a published poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(published_poll)
    assert_selector '.poll-state', text: 'published'

    click_on 'Start poll'
    assert_selector '.poll-state', text: 'started'
  end

  test 'admin closes a started poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(started_poll)

    assert_selector '.poll-state', text: 'started'

    click_on 'Close poll'
    assert_selector '.poll-state', text: 'closed'
  end

  test 'admin archives a closed poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(closed_poll)

    assert_selector '.poll-state', text: 'closed'

    click_on 'Archive poll'
    assert_selector '.poll-state', text: 'archived'
  end

  # delete

  test 'admin deletes an unstarted poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(published_poll)

    within('.delete-section') do
      assert_selector 'h2', text: 'Delete poll'
      click_on 'Delete'
    end

    assert_selector 'h1', text: 'All polls'
  end

  test 'admin cannot delete a started poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(started_poll)

    click_on 'Manage'

    within('.delete-section') do
      assert_selector 'h2', text: 'Delete poll'
      assert_text 'This poll can no longer be delete since it has been started.'
      assert_text 'You may archive the poll after it is closed.'
    end
  end
end
