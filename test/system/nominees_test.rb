require 'application_system_test_case'

class NomineesTest < ApplicationSystemTestCase
  setup do
    @best_actor_poll = polls(:best_actor)
    @best_actor_bill_murray = nominees(:best_actor_bill_murray)
  end

  test 'visiting the nominee form' do
    visit poll_path(@best_actor_poll)

    assert_selector 'a', text: 'Add nominee' do |add_nominee_link|
      assert_equal 'Add nominee', add_nominee_link['aria-label']
      assert_equal 'Add nominee', add_nominee_link['title']
      add_nominee_link.click
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

    delete_nominee_link = find('.nominees a[data-method="delete"]', match: :first)
    assert_equal 'Delete', delete_nominee_link.text
    assert_equal 'Delete nominee', delete_nominee_link['aria-label']
    assert_equal 'Delete nominee', delete_nominee_link['title']

    assert_difference -> { all('.nominees li.nominee').count }, -1 do
      click_with_delete(delete_nominee_link)
    end
  end
end
