class PollArchivingForm
  include ActiveModel::Model

  attr_reader :poll

  validate :archivable?

  def initialize(poll)
    @poll = poll
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Archiving')
  end

  def save!
    return unless valid?

    poll.archive!
  end

  private

  def archivable?
    return if poll.archivable?

    errors.add(:base, 'Poll is not archivable')
  end
end
