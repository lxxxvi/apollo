class Poll < ApplicationRecord
  before_create :create_custom_id

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end