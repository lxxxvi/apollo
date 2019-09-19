class PollTokenForm
  include ActiveModel::Model
  MINIMUM_AMOUNT = 1
  MAXIMUM_AMOUNT = 1_000

  attr_reader :poll, :amount

  validates :amount,
            numericality: { greater_than_or_equal_to: MINIMUM_AMOUNT,
                            only_integer: true,
                            less_than_or_equal_to: MAXIMUM_AMOUNT }
  validate :maximum_tokens_not_reached

  def initialize(poll, params = {})
    @poll = poll
    @amount = params[:amount]&.to_i || MINIMUM_AMOUNT
    @token_values = []
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Poll::Token')
  end

  def save
    return unless valid?

    generate_tokens
    poll.save
  end

  private

  def generate_tokens
    poll.tokens.new(token_values)
  end

  def token_values
    @token_values = TokenValuesGenerator.generate_values(amount)
                                        .map { |value| { value: value } }
  end

  def maximum_tokens_not_reached
    errors.add(:amount, maximum_tokens_reached_message) if new_token_count > MAXIMUM_AMOUNT
  end

  def maximum_tokens_reached_message
    "is too high, total number of tokens may not exceed #{MAXIMUM_AMOUNT}"
  end

  def new_token_count
    (poll.tokens.count + amount)
  end
end
