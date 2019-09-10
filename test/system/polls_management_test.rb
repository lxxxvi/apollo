require 'application_system_test_case'

class PollsManagementTest < ApplicationSystemTestCase
  attr_reader :draft_poll, :published_poll

  setup do
    @draft_poll = polls(:best_actress_draft)
    @published_poll = polls(:best_actor_published)
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

  test 'admin visits an drafted poll' do
    sign_in_as(:julia_roberts)

    visit polls_path

    click_on draft_poll.title

    assert_selector 'h1', text: 'Best actress'
    assert_selector 'p', text: 'Who is she?'
    assert_selector 'body', text: 'Julia Roberts'
    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  # edit

  test 'admin edits an unstarted poll' do
    sign_in_as(:julia_roberts)

    visit edit_poll_path(published_poll)

    within('form') do
      fill_in('Title', with: 'Best actress')
      fill_in('Description', with: 'Who is she?')
      click_on('Update Poll')
    end

    assert_selector 'h1', text: 'Best actress'
  end

  test 'admin cannot publish a poll if the email is not verified' do
    sign_in_as(:julia_roberts)

    user = users(:julia_roberts)
    user.update(email_verified_at: nil)

    visit poll_path(draft_poll)

    assert_selector '.poll-state', text: 'Draft'
    assert_text 'In order to publish this poll you need to verify your email first.'
    assert_selector ".poll-state-actions input[value='Publish poll']", count: 0
  end

  test 'admin publishes a drafted a poll' do
    sign_in_as(:julia_roberts)

    visit poll_path(draft_poll)
    assert_selector '.poll-state', text: 'Draft'

    click_on 'Publish poll'
    assert_selector '.poll-state', text: 'Published'
  end

  # delete

  test 'deletes an unstarted poll' do
    sign_in_as(:julia_roberts)

    visit poll_path(published_poll)

    button = find('.poll-actions a', text: 'Delete')
    click_with_delete(button)

    assert_selector 'h1', text: 'All polls'
  end
end
