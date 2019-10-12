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
  scope :listed, -> { timestamp_between(:published_at, :archived_at).not_deleted.not_drafted }
  scope :timestamp_between, ->(from_column, until_column, timestamp = Time.zone.now) {
    where(":timestamp BETWEEN COALESCE(#{from_column}, '1000-01-01')
                          AND COALESCE(#{until_column}, '9999-12-31')",
          timestamp: timestamp)
  }
  scope :of_user, ->(user) { where(user: user) }

  def to_param
    custom_id
  end

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
