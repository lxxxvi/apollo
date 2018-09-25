require 'application_system_test_case'

class PollsTest < ApplicationSystemTestCase
  attr_reader :best_actor_poll

  setup do
    @best_actor_poll = polls(:best_actor)
  end

  # show

  test 'visiting a poll' do
    visit poll_path(best_actor_poll)

    assert_selector 'h1', text: 'Best actor'
    assert_selector 'p', text: 'Who is he?'
  end

  # new

  test 'visiting the new form' do
    visit new_poll_path

    assert_selector('h1', text: 'New poll')
    assert_selector('form.new_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a.ui.button', text: 'Cancel')
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

    assert_selector 'h1', text: 'New poll'

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
    visit poll_path(best_actor_poll)
    assert_selector 'a.ui.secondary.button[href$="edit"]', text: 'Edit'
    click_on('Edit')

    assert_selector('h1', text: 'Edit poll')
    assert_selector('form.edit_poll') do
      assert_selector('input[type="submit"]')
      assert_selector('a.ui.button', text: 'Cancel')
      assert_equal 2, all('input').count, 'There should be exact 2 input fields'
    end
    find_label_and_input_for('poll_title')
    find_label_and_textarea_for('poll_description')
    assert_equal 'Best actor', find('input#poll_title').value
    assert_equal 'Who is he?', find('textarea#poll_description').value
  end

  test 'submit empty edit poll form' do
    visit edit_poll_path(best_actor_poll)

    within('form.edit_poll') do
      fill_in('Title', with: '')
      fill_in('Description', with: '')
      click_on('Update Poll')
    end

    assert 'h1', text: 'Edit poll'

    within('form.edit_poll') do
      assert_equal 1, all('input[aria-invalid="true"]').count
    end
  end

  test 'submit completed edit poll form' do
    visit edit_poll_path(best_actor_poll)

    within('form.edit_poll') do
      fill_in('Title', with: 'Best actress')
      fill_in('Description', with: 'Who is she?')
      click_on('Update Poll')
    end

    assert_selector 'h1', text: 'Best actress'
  end

  # delete

  test 'delete a poll' do
    visit poll_path(best_actor_poll)
    assert_selector 'a.ui.red.basic.button[data-method="delete"]', text: 'Delete'
    click_on('Delete')
    accept_alert

    assert_selector 'h1', text: 'Home'
  end

  private

  def find_label_and_input_for(html_id)
    find_label_for html_id
    assert_selector "input##{html_id}"
  end

  def find_label_and_textarea_for(html_id)
    find_label_for html_id
    assert_selector "textarea##{html_id}"
  end

  def find_label_for(html_id)
    assert_selector "label[for='#{html_id}']"
  end
end
