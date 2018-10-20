class Token < ApplicationRecord
  before_validation :create_value

  belongs_to :poll
  belongs_to :nominee, optional: true

  validates :value, presence: true
  validates :value, uniqueness: { scope: :poll }

  def to_param
    value
  end

  private

  def create_value
    self.value ||= SecureRandom.alphanumeric(12)
  end
end
