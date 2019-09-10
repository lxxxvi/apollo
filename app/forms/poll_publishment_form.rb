class PollPublishmentForm
  include ActiveModel::Model

  attr_reader :poll

  validate :publishable?

  def initialize(poll)
    @poll = poll
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Publishment')
  end

  def save!
    return unless valid?

    poll.publish!
  end

  private

  def publishable?
    return if poll.publishable?

    errors.add(:base, 'Poll is not publishable')
  end
end
