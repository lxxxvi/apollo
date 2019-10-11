class Admin::PollStateChangeForm
  include ActiveModel::Model
  include ActionView::Helpers::UrlHelper

  ACTION_TEXTS = {
    default: 'Publish poll',
    started: 'Start poll',
    closed: 'Close poll',
    archived: 'Archive poll',
    deleted: 'Delete poll'
  }.freeze

  attr_reader :poll, :next_state

  validate :validate_poll

  def initialize(poll, params = {})
    @poll = poll
    @next_state = params[:next_state]
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Admin::Poll::StateChange')
  end

  def save
    return unless valid?

    poll.save
  end

  def to_url
    url_helpers.admin_poll_state_change_path(poll, poll.state)
  end

  def action_text
    ACTION_TEXTS[next_state.to_sym] || ACTION_TEXTS[:default]
  end

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def validate_poll
    poll.transit_to!(next_state)
    return if poll.valid?

    errors.copy!(poll.errors)
  end
end
