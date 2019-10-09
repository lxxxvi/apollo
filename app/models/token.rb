class Token < ApplicationRecord
  before_validation :create_value

  belongs_to :poll
  belongs_to :nominee, optional: true

  validates :value, presence: true
  # validates :value, uniqueness: { scope: :poll } TODO: make me fast

  scope :untouched, -> { where(touched_at: nil) }

  def redeemed?
    nominee.present?
  end

  def to_param
    value
  end

  private

  def create_value
    self.value ||= TokenValuesGenerator.generate_values.first
  end
end
