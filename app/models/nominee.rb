class Nominee < ApplicationRecord
  after_initialize :initialize_image_placeholder
  before_validation :create_custom_id

  validates :name, presence: true
  validates :custom_id, presence: true
  validates :name, uniqueness: { scope: :poll }
  validates :custom_id, uniqueness: { scope: :poll }

  belongs_to :poll

  scope :of_poll, ->(poll) { where(poll: poll) }
  scope :ordered_by_name, -> { order(name: :asc) }

  def to_param
    custom_id
  end

  private

  def initialize_image_placeholder
    self.image_placeholder ||= ImagePlaceholder.base64
  end

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
