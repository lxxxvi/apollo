class Poll < ApplicationRecord
  include Statable
  LISTED_STATES = %i[published started closed archived].freeze

  before_validation :create_custom_id

  validates :title, presence: true
  validates :custom_id, presence: true

  belongs_to :user

  has_many :nominees, dependent: :destroy
  has_many :tokens, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }
  scope :listed, -> { in_state(LISTED_STATES) }
  scope :of_user, ->(user) { where(user: user) }

  def to_param
    custom_id
  end

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
