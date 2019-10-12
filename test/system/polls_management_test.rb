require 'application_system_test_case'

class PollsManagementTest < ApplicationSystemTestCase
  attr_reader :drafted_poll, :published_poll, :started_poll, :closed_poll, :archived_poll

  setup do
    @drafted_poll = polls(:best_actress_drafted)
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
  end

  test 'admin visits admins polls index' do
    sign_in_as(:julia_roberts)

    click_on 'My polls'

    assert_selector 'h1', text: 'My polls'
    assert_selector '.polls .poll-state', text: 'archived'

    click_on 'All polls'

    assert_selector 'h1', text: 'All polls'
  end

  test 'create a new poll' do
    sign_out
    visit new_poll_path

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

  # show

  test 'admin visits an drafteded poll' do
    sign_in_as(:julia_roberts)

    visit polls_path

    click_on drafted_poll.title

    assert_selector 'h1', text: 'Best actress'
    assert_selector 'p', text: 'Who is she?'
    assert_selector 'body', text: 'Julia Roberts'
    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  test 'admin visits admin area of a poll' do
    sign_in_as(:julia_roberts)

    visit polls_path
    click_on drafted_poll.title
    click_on 'Manage'

    assert_selector 'h1', text: 'Manage poll'
  end

  # edit

  test 'admin edits an unstarted poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(published_poll)

    within('.information-section form') do
      fill_in('Title', with: 'Best actress')
      fill_in('Description', with: 'Who is she?')
      click_on('Update Poll')
    end

    assert_selector 'h1', text: 'Manage poll'
  end

  test 'buttons are hidden depending on state' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(published_poll)

    assert_difference -> { submit_buttons.count }, -2, 'Update and delete buttons should disappear' do
      click_on 'Start'
      assert_inputs_disabled
    end

    assert_difference -> { submit_buttons.count }, -1, 'Update schedule button should disappear' do
      click_on 'Close'
      assert_inputs_disabled
    end

    click_on 'Archive'

    assert_equal 0, submit_buttons.count, 'Should not have any submit buttons after Archive'
  end

  test 'admin cannot publish a poll if the email is not verified' do
    sign_in_as(:julia_roberts)

    user = users(:julia_roberts)
    user.update(email_verified_at: nil)

    visit admin_poll_path(drafted_poll)

    assert_selector '.poll-state', text: 'drafted'
    assert_text 'In order to publish this poll you need to verify your email first.'
    assert_selector ".poll-state-actions input[value='Publish poll']", count: 0
  end

  test 'admin publishes a drafteded a poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(drafted_poll)
    assert_selector '.poll-state', text: 'drafted'

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
      click_on 'Delete poll'
    end

    assert_selector 'h1', text: 'All polls'
  end

  test 'admin cannot delete a started poll' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(started_poll)

    within('.delete-section') do
      assert_selector 'h2', text: 'Delete poll'
      assert_text 'This poll can no longer be delete since it has been started.'
      assert_text 'You may archive the poll after it is closed.'
    end
  end

  test 'admin sets closed at for a published poll' do
    sign_in_as(:julia_roberts)

    reference_date = DateTime.new(2019, 1, 1, 1, 1, 1)

    travel_to reference_date do
      visit admin_poll_path(published_poll)

      select '(GMT+10:00) Sydney', from: 'Time zone'

      select '2020', from: 'admin_poll[closed_at(1i)]'
      select 'February', from: 'admin_poll[closed_at(2i)]'
      select '29', from: 'admin_poll[closed_at(3i)]'

      select '02', from: 'admin_poll[closed_at(4i)]'
      select '03', from: 'admin_poll[closed_at(5i)]'

      click_on 'Update Poll'

      assert_text 'Poll has been updated'
    end
  end

  private

  def submit_buttons
    all("input[type='submit']")
  end

  def assert_inputs_disabled
    assert_equal find_all("input[type='text'], textarea").count,
                 find_all("[disabled='disabled']").count,
                 'All input elements should be disabled'
  end
end
