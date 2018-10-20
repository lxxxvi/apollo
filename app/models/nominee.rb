class Nominee < ApplicationRecord
  before_validation :create_custom_id

  validates :name, presence: true
  validates :custom_id, presence: true

  belongs_to :poll

  def to_param
    custom_id
  end

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
