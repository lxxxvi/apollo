class PollVotingForm
  include ActiveModel::Model

  attr_reader :token, :token_value, :nominee_id

  validate :nominee_selected?
  validate :nominee_exists?

  def initialize(token, params = {})
    @token = token
    @token_value = @token.value
    @nominee_id = params[:nominee_id]
  end

  def self.model_name
    ActiveModel::Name.new(nil, self, 'Poll::Voting')
  end

  def save!
    return unless valid?

    token.update!(nominee: nominee)
  end

  private

  def nominee_selected?
    return if nominee_id.present?

    errors.add(:base, 'Please select a nominee')
  end

  def nominee
    @nominee ||= Nominee.of_poll(token.poll).find_by(id: @nominee_id)
  end

  def nominee_exists?
    return if nominee.present?

    errors.add(:base, 'Nominee does not exist')
  end
end
