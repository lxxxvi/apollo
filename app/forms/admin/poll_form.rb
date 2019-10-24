class Admin::PollForm
  include ActiveModel::Model

  delegate :persisted?, :new_record?, :to_param, to: :poll
  attr_reader :poll, :title, :description

  validates :title, :description, presence: true
  validate :poll_is_editable

  def initialize(poll, params = {})
    @poll = poll
    @title = params[:title] || poll[:title]
    @description = params[:description] || poll[:description]
  end

  def save
    return unless valid?

    poll.update(title: title, description: description)
  end

  def model_name
    ActiveModel::Name.new(self, nil, 'Admin::Poll')
  end

  private

  def poll_is_editable
    return if poll.editable?

    errors.add(:base, 'Poll cannot be edited anymore')
  end
end
