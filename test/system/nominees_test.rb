require 'application_system_test_case'

class NomineesTest < ApplicationSystemTestCase
  setup do
    @poll = polls(:best_actor_published)
  end

  test 'visiting the nominee form' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(@poll)

    click_on 'Manage'

    within('.nominees-section') do
      click_on 'Add nominee'
    end

    assert_selector('h1', text: 'Add nominee')
    assert_selector('form.new_nominee') do
      assert_selector('input[type="submit"]')
      assert_selector('a', text: 'Cancel')
    end

    find_label_and_input_for('nominee_name')
    find_label_and_textarea_for('nominee_description')
  end

  test 'submit new nominee form empty' do
    sign_in_as(:julia_roberts)

    visit new_admin_poll_nominee_path(@poll)

    assert_selector('h1', text: 'Add nominee')
    click_on('Create Nominee')

    assert_selector('h1', text: 'Add nominee')
    assert_selector('input[aria-invalid="true"]', count: 1)

    within('form.new_nominee') do
      fill_in('Name', with: 'John Malkovich')
      fill_in('Description', with: 'Being John Malkovich')
    end

    click_on('Create Nominee')

    assert_selector('h1', text: 'Best actor')
    assert_selector('h3', text: 'John Malkovich')
  end

  test 'edit an nominee' do
    sign_in_as(:julia_roberts)

    visit admin_poll_path(@poll)

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
    sign_in_as(:julia_roberts)

    visit admin_poll_path(@poll)

    assert_difference -> { all('.nominees li.nominee').count }, -1 do
      within('.nominee:first-child') do
        delete_nominee_button = find 'a', text: 'Delete'
        click_with_delete(delete_nominee_button)
      end
    end
  end
end
