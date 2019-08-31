class PollForm
  include ActiveModel::Model

  delegate :persisted?, :new_record?, :to_param, to: :poll
  attr_reader :poll, :email, :title, :description

  validates :title, presence: true
  validates :email, presence: true, if: :new_record?

  def initialize(poll, params = {})
    @poll = poll
    @email, @title, @description = params.values_at(:email, :title, :description)
  end

  def save
    return unless valid?

    poll.assign_attributes(title: title, description: description)
    poll_user.polls << poll
    poll_user.save!
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Poll')
  end

  def poll_user
    @poll_user ||= poll.user || User.find_or_initialize_by(email: email)
  end
end
