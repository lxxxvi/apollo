require 'application_system_test_case'

class PollsTest < ApplicationSystemTestCase
  attr_reader :best_actor_poll

  NEW_POLL_TEXT = 'New poll'.freeze
  EDIT_POLL_TEXT = 'Edit'.freeze
  DELETE_POLL_TEXT = 'Delete'.freeze
  PUBLISH_POLL_TEXT = 'Publish poll'.freeze

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  # show

  test 'visiting a poll' do
    visit poll_path(best_actor_poll)

    assert_selector 'h1', text: 'Best actor'
    assert_selector 'p', text: 'Who is he?'
    assert_selector 'body', text: 'Bryan Cranston'
    assert_selector 'a', text: 'Back to overview', &:click
    assert_selector 'h1', text: 'All polls'
  end

  # new

  test 'visiting the new form' do
    visit new_poll_path

    assert_selector('h1', text: NEW_POLL_TEXT)
    assert_selector('form.new_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a', text: 'Cancel')
    end
    find_label_and_input_for('poll_title')
    find_label_and_input_for('poll_email')
    find_label_and_textarea_for('poll_description')
  end

  test 'submit empty new poll form' do
    visit new_poll_path

    within('form.new_poll') do
      click_on('Create Poll')
    end

    assert_selector 'h1', text: NEW_POLL_TEXT

    assert_selector('form.new_poll') do
      assert_equal 2, all('input[aria-invalid="true"]').count
    end
  end

  test 'submit complete new poll form' do
    visit new_poll_path

    within('form.new_poll') do
      fill_in('Title', with: 'Best singer')
      fill_in('Email', with: 'best-singer@apollo.test')
      fill_in('Description', with: 'Lorem ipsum')
      click_on('Create Poll')
    end

    assert_selector 'h1', text: 'Best singer'
  end

  # edit

  test 'visiting the edit form' do
    sign_in_as(:julia_roberts)

    visit poll_path(best_actor_poll)

    edit_poll_button.click

    assert_selector('h1', text: EDIT_POLL_TEXT)
    assert_selector('form.edit_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a', text: 'Cancel')
      assert_equal 2, all('input').count, 'There should be exact 2 input fields'
    end

    find_label_and_input_for('poll_title')
    find_label_and_textarea_for('poll_description')
    assert_equal 'Best actor', find('input#poll_title').value
    assert_equal 'Who is he?', find('textarea#poll_description').value
  end

  test 'submit empty edit poll form' do
    sign_in_as(:julia_roberts)

    visit edit_poll_path(best_actor_poll)

    within('form') do
      fill_in('Title', with: '')
      fill_in('Description', with: '')
      click_on('Update Poll')
    end

    assert 'h1', text: EDIT_POLL_TEXT

    within('form') do
      assert_equal 1, all('input[aria-invalid="true"]').count
    end
  end

  test 'submit completed edit poll form' do
    sign_in_as(:julia_roberts)

    visit edit_poll_path(best_actor_poll)

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
    user.update!(email_verified_at: nil)

    visit poll_path(best_actor_poll)

    assert_selector '.poll-state', text: 'Draft'

    assert_text 'In order to publish this poll you need to verify your email first.'

    assert_raise(Capybara::ElementNotFound) { publish_poll_button }
  end

  test 'admin publishes a poll' do
    sign_in_as(:julia_roberts)

    visit poll_path(best_actor_poll)

    publish_poll_button.click

    assert_selector '.poll-state', text: 'Published'
  end

  # delete

  test 'delete a poll' do
    sign_in_as(:julia_roberts)

    visit poll_path(best_actor_poll)

    click_with_delete(delete_poll_button)

    assert_selector 'h1', text: 'All polls'
  end

  test 'non-admin does not see edit button' do
    sign_in_as(:tina_fey)
    visit poll_path(best_actor_poll)

    assert_raise(Capybara::ElementNotFound) { edit_poll_button }
  end

  test 'non-admin does not see delete button' do
    sign_in_as(:tina_fey)
    visit poll_path(best_actor_poll)

    assert_raise(Capybara::ElementNotFound) { delete_poll_button }
  end

  private

  def edit_poll_button
    find '.poll-actions a', text: EDIT_POLL_TEXT
  end

  def delete_poll_button
    find '.poll-actions a', text: DELETE_POLL_TEXT
  end

  def publish_poll_button
    find ".poll-state-actions input[value='#{PUBLISH_POLL_TEXT}']"
  end
end
