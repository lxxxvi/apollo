require 'application_system_test_case'

class NomineesTest < ApplicationSystemTestCase
  setup do
    @best_actor_poll = polls(:best_actor)
    @best_actor_bill_murray = nominees(:best_actor_bill_murray)
  end

  test 'visiting the nominee form' do
    visit poll_path(@best_actor_poll)

    add_nominee_button = find('a[href$="nominees/new"]')
    assert_equal 'Add nominee', add_nominee_button['aria-label']
    assert_equal 'Add nominee', add_nominee_button['title']

    add_nominee_button.click

    assert_selector('h1', text: 'Add nominee')
    assert_selector('form.new_nominee') do
      assert_selector('input[type="submit"]')
      assert_selector('a.ui.button', text: 'Cancel')
    end

    find_label_and_input_for('nominee_name')
    find_label_and_textarea_for('nominee_description')
  end

  test 'submit new nominee form empty' do
    visit new_poll_nominee_path(@best_actor_poll)

    assert_selector('h1', text: 'Add nominee')
    click_on('Create Nominee')

    assert_selector('h1', text: 'Add nominee')
    assert_selector('input[aria-invalid="true"]', count: 1)
  end

  test 'submit new nominee form complete' do
    visit new_poll_nominee_path(@best_actor_poll)

    assert_selector('h1', text: 'Add nominee')

    within('form.new_nominee') do
      fill_in('Name', with: 'John Malkovich')
      fill_in('Description', with: 'Being John Malkovich')
    end

    click_on('Create Nominee')

    assert_selector('h1', text: 'Best actor')
    assert_selector('body', text: 'John Malkovich')
  end

  test 'edit an nominee' do
    visit poll_path(@best_actor_poll)

    within('.nominee:first-child') do
      click_on 'Edit'
    end

    assert_selector('h1', text: 'Edit nominee')

    within('form.edit_nominee') do
      fill_in('Name', with: 'Bill Ghost-Bustin Murray')
      fill_in('Description', with: 'Aint afraid of no ghost')
    end

    click_on('Update Nominee')

    assert_selector('h1', text: 'Best actor')
    assert_selector('body', text: 'Ghost-Bustin')
    assert_selector('body', text: 'afraid')
  end

  test 'delete nominee' do
    visit poll_path(@best_actor_poll)

    delete_nominee_button = find('.nominee:first-child a[data-method="delete"]')
    assert_equal 'Delete nominee', delete_nominee_button['aria-label']
    assert_equal 'Delete nominee', delete_nominee_button['title']

    assert_difference -> { all('.nominee').count }, -1 do
      delete_nominee_button.click
      accept_alert
    end
  end
end
