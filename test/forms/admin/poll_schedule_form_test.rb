require 'test_helper'

class Admin::PollScheduleFormTest < ActiveSupport::TestCase
  test 'closed_at for new poll, default closed at' do
    reference_date_time = DateTime.new(2019, 2, 2, 2, 2, 2)

    travel_to reference_date_time do
      form = Admin::PollScheduleForm.new(Poll.new)

      assert_equal 'UTC', form.time_zone
      assert_equal DateTime.new(2019, 2, 9, 2, 0, 0), form.closed_at
      assert_equal DateTime.new(2019, 2, 9, 2, 0, 0), form.closed_at_utc
    end
  end

  test 'closed_at for new poll, no time zone, custom closed at' do
    params = to_date_time_params(:closed_at, 2019, 2, 2, 2, 2, 2)

    form = Admin::PollScheduleForm.new(Poll.new, params)

    assert_equal 'UTC', form.time_zone
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2), form.closed_at
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2, '+00'), form.closed_at_utc
  end

  test 'closed_at for new poll, custom closed at' do
    closed_at_params = to_date_time_params(:closed_at, 2019, 2, 2, 2, 2, 2)
    params = { time_zone: 'Berlin' }.merge(closed_at_params)

    form = Admin::PollScheduleForm.new(Poll.new, params)

    assert_equal 'Berlin', form.time_zone
    assert_equal DateTime.new(2019, 2, 2, 2, 2, 2), form.closed_at
    assert_equal DateTime.new(2019, 2, 2, 1, 2, 2, '+00'), form.closed_at_utc
  end

  test 'closed_at for new poll, custom closed at, daylight saving time' do
    closed_at_params = to_date_time_params(:closed_at, 2019, 10, 27, 1, 0)
    params = { time_zone: 'Berlin' }.merge(closed_at_params)

    form = Admin::PollScheduleForm.new(Poll.new, params)

    assert_equal 'Berlin', form.time_zone
    assert_equal DateTime.new(2019, 10, 27, 1, 0, 0), form.closed_at
    assert_equal DateTime.new(2019, 10, 26, 23, 0, 0, '+00'), form.closed_at_utc
  end

  test 'started_at' do
    started_at_params = to_date_time_params(:started_at, 2010, 1, 1, 1, 0)
    params = { time_zone: 'Berlin' }.merge(started_at_params)

    form = Admin::PollScheduleForm.new(Poll.new, params)

    assert_equal 'Berlin', form.time_zone
    assert_equal DateTime.new(2010, 1, 1, 1, 0, 0), form.started_at
    assert_equal DateTime.new(2010, 1, 1, 0, 0, 0, '+00'), form.started_at_utc
  end
end
