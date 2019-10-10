class Token < ApplicationRecord
  before_validation :create_value

  belongs_to :poll
  belongs_to :nominee, optional: true

  validates :value, presence: true
  # validates :value, uniqueness: { scope: :poll } TODO: make me fast

  scope :unused, -> { where(first_visited_at: nil) }

  def used?
    first_visited_at.present?
  end

  def redeemed?
    nominee.present?
  end

  def to_param
    value
  end

  def mark_first_visit!
    return if used?

    update!(first_visited_at: Time.zone.now)
  end

  private

  def create_value
    self.value ||= TokenValuesGenerator.generate_values.first
  end
end
