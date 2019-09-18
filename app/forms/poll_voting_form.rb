class PollVotingForm
  include ActiveModel::Model

  attr_reader :poll, :token_value, :nominee_id

  validate :valid_token?
  validate :valid_nominee?
  validate :poll_started?

  def initialize(poll, params = {})
    @poll = poll
    @token_value, @nominee_id = params.values_at(:token_value, :nominee_id)
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Voting')
  end

  def save!
    return unless valid?

    token.update!(nominee: nominee)
  end

  def token
    @token ||= @poll.tokens.find_by!(value: @token_value)
  end

  private

  def nominee
    @nominee ||= @poll.nominees.find_by!(id: @nominee_id)
  end

  def valid_token?
    return if token.present?

    errors.add(:base, 'Token does not exist')
  end

  def valid_nominee?
    return if nominee.present?

    errors.add(:base, 'Nominee does not exist')
  end

  def poll_started?
    return if poll.started?

    errors.add(:base, 'Poll is not started')
  end
end
