require 'application_system_test_case'

class NomineesTest < ApplicationSystemTestCase
  setup do
    @published_poll = polls(:best_actor_published)
    @started_poll = polls(:best_singer_started)
    @closed_poll = polls(:best_movie_closed)
    @archived_poll = polls(:best_song_archived)
  end

  test 'visiting the nominees index' do
    sign_in_as(:julia_roberts)
    visit admin_poll_path(@published_poll)
    click_on 'Nominees'
    assert_selector 'h1', text: 'Manage poll'
    assert_selector 'h2', text: 'Nominees'
  end

  test 'visiting the nominee form' do
    sign_in_as(:julia_roberts)

    visit admin_poll_nominees_path(@published_poll)

    click_on 'Add nominee'

    assert_selector('h1', text: 'Add nominee')
    assert_selector('form.new_nominee') do
      assert_selector('input[type="submit"]')
      assert_selector('a', text: 'Cancel')
    end

    find_label_and_input_for('nominee_name')
    find_label_and_textarea_for('nominee_description')
  end

  test 'submit new nominee form' do
    sign_in_as(:julia_roberts)

    visit new_admin_poll_nominee_path(@published_poll)

    assert_selector('h1', text: 'Add nominee')
    click_on('Create Nominee')

    assert_selector('h1', text: 'Add nominee')
    assert_selector('input[aria-invalid="true"]', count: 1)

    within('form.new_nominee') do
      fill_in('Name', with: 'John Malkovich')
      fill_in('Description', with: 'Being John Malkovich')
    end

    click_on('Create Nominee')

    assert_selector('h1', text: 'Manage poll')

    assert_selector('h3', text: 'John Malkovich')
  end

  test 'edit an nominee' do
    sign_in_as(:julia_roberts)

    visit admin_poll_nominees_path(@published_poll)

    within('.nominee:first-child') do
      click_on 'Edit'
    end

    assert_selector('h1', text: 'Edit nominee')

    within('form.edit_nominee') do
      fill_in('Name', with: 'Bill Ghost-Bustin Murray')
      fill_in('Description', with: 'Aint afraid of no ghost')
    end

    click_on('Update Nominee')

    assert_selector('h1', text: 'Manage poll')

    assert_selector 'h3', text: 'Ghost-Bustin'
    assert_text 'afraid'
  end

  test 'delete nominee' do
    sign_in_as(:julia_roberts)

    visit admin_poll_nominees_path(@published_poll)

    assert_difference -> { all('.nominees li.nominee').count }, -1 do
      within('.nominee:first-child') do
        delete_nominee_button = find 'a', text: 'Delete'
        click_with_delete(delete_nominee_button)
      end
    end
  end

  test 'add, edit and delete buttons disappear after poll has started' do
    sign_in_as(:julia_roberts)

    visit admin_poll_nominees_path(@published_poll)

    assert_changes -> { nominees_section_links.count }, to: 0 do
      visit admin_poll_nominees_path(@started_poll)
    end

    visit admin_poll_nominees_path(@closed_poll)
    assert_equal 0, nominees_section_links.count

    visit admin_poll_nominees_path(@archived_poll)
    assert_equal 0, nominees_section_links.count
  end

  private

  def nominees_section_links
    all('.nominees-section a')
  end
end
