class Poll < ApplicationRecord
  before_create :create_custom_id

  validates :title, presence: true
  validates :email, presence: true

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
