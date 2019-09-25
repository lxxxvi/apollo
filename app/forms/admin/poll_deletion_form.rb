class Admin::PollDeletionForm
  include ActiveModel::Model

  attr_reader :poll

  validate :deletable?

  def initialize(poll)
    @poll = poll
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Admin::Poll::Deletion')
  end

  def save!
    return unless valid?

    poll.delete!
  end

  private

  def deletable?
    return if poll.deletable?

    errors.add(:base, 'Poll is not deletable')
  end
end
