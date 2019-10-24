require 'test_helper'

class Admin::PollScheduleFormTest < ActiveSupport::TestCase
  test 'closed_at_for_time_zone for new poll, default closed at' do
    reference_date_time = DateTime.new(2019, 2, 2, 2, 2, 2)

    travel_to reference_date_time do
      form = Admin::PollScheduleForm.new(Poll.new)

      assert_equal 'UTC', form.time_zone
      assert_equal DateTime.new(2019, 2, 9, 2, 0, 0), form.closed_at
      assert_equal DateTime.new(2019, 2, 9, 2, 0, 0), form.closed_at_utc
    end
  end

  test 'closed_at_for_time_zone for new poll, no time zone, custom closed at' do
    reference_date_time = DateTime.new(2019, 2, 2, 2, 2, 2)

    form = Admin::PollScheduleForm.new(Poll.new, closed_at: reference_date_time)

    assert_equal 'UTC', form.time_zone
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2), form.closed_at
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2, '+00'), form.closed_at_utc
  end

  test 'closed_at_for_time_zone for new poll, custom closed at' do
    reference_date_time = DateTime.new(2019, 2, 2, 2, 2, 2)

    form = Admin::PollScheduleForm.new(Poll.new, time_zone: 'Berlin', closed_at: reference_date_time)

    assert_equal 'Berlin', form.time_zone
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2), form.closed_at
    assert_equal DateTime.new(2019, 2, 2, 1, 2, 2, '+00'), form.closed_at_utc
  end

  test 'closed_at_for_time_zone for new poll, custom closed at, daylight saving time' do
    reference_date_time = DateTime.new(2019, 10, 27, 1, 0)

    form = Admin::PollScheduleForm.new(Poll.new, time_zone: 'Berlin', closed_at: reference_date_time)

    assert_equal 'Berlin', form.time_zone
    assert_equal DateTime.new(2019, 10, 27, 1, 0, 0), form.closed_at
    assert_equal DateTime.new(2019, 10, 26, 23, 0, 0, '+00'), form.closed_at_utc
  end
end
