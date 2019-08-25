require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

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

  def click_with_delete(element)
    if Capybara.current_driver == :rack_test
      page.driver.submit :delete, element['href'], {}
    else
      element.click
      accept_alert
    end
  end
end
