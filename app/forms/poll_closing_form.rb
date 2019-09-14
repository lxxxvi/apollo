class PollClosingForm
  include ActiveModel::Model

  attr_reader :poll

  validate :closable?

  def initialize(poll)
    @poll = poll
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Closing')
  end

  def save!
    return unless valid?

    poll.close!
  end

  private

  def closable?
    return if poll.closable?

    errors.add(:base, 'Poll is not closable')
  end
end
