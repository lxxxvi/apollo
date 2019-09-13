class PollStartForm
  include ActiveModel::Model

  attr_reader :poll

  validate :startable?

  def initialize(poll)
    @poll = poll
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Start')
  end

  def save!
    return unless valid?

    poll.start!
  end

  private

  def startable?
    return if poll.startable?

    errors.add(:base, 'Poll is not startable')
  end
end
