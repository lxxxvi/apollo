class Admin::PollScheduleForm
  include ActiveModel::Model
  NAME = 'poll_schedule'.freeze

  delegate :persisted?, :new_record?, :to_param, to: :poll
  attr_reader :poll, :params, :time_zone, :started_at, :closed_at

  validates :time_zone, :started_at, :closed_at, presence: true

  def initialize(poll, params = {})
    @poll = poll
    @params = params

    set_time_zone
    set_started_at
    set_closed_at
  end

  def save
    return unless valid?

    poll.update!(time_zone: time_zone,
                 started_at: started_at_utc,
                 closed_at: closed_at_utc)
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Poll')
  end

  def closed_at_utc
    merge_with_time_zone(closed_at)&.utc
  end

  def started_at_utc
    merge_with_time_zone(started_at)&.utc
  end

  def form_name
    self.class::NAME
  end

  private

  def set_time_zone
    @time_zone = params[:time_zone] || @poll[:time_zone]
  end

  def set_started_at
    params_started_at = Poll.new(params).started_at # parses :started_at nicely
    poll_or_default_started_at = to_time_zone(@poll[:started_at] || default_started_at)

    @started_at = params_started_at || poll_or_default_started_at
  end

  def set_closed_at
    params_closed_at = Poll.new(params).closed_at # parses :closed_at nicely
    poll_or_default_closed_at = to_time_zone(@poll[:closed_at] || default_closed_at)

    @closed_at = params_closed_at || poll_or_default_closed_at
  end

  def default_started_at
    2.hours.from_now.at_beginning_of_hour
  end

  def default_closed_at
    1.week.from_now.at_beginning_of_hour
  end

  def merge_with_time_zone(date_time)
    date_time&.asctime&.in_time_zone(time_zone)
  end

  def to_time_zone(date_time)
    date_time.in_time_zone(time_zone)
  end
end
