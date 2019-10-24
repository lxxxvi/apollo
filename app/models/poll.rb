class Poll < ApplicationRecord
  include Statable
  LISTED_STATES = %i[published started closed archived].freeze

  after_initialize :create_custom_id
  after_initialize :initialize_time_zone

  validates :title, :time_zone, presence: true

  belongs_to :user

  has_many :nominees, dependent: :destroy
  has_many :tokens, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }
  scope :listed, -> { not_deleted.not_drafted }
  scope :of_user, ->(user) { where(user: user) }

  def to_param
    custom_id
  end

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end

  def initialize_time_zone
    self.time_zone ||= Rails.configuration.default_time_zone.name
  end
end
