class Nominee < ApplicationRecord
  before_create :create_custom_id

  belongs_to :poll

  def to_param
    custom_id
  end

  private

  def create_custom_id
    self.custom_id ||= SecureRandom.alphanumeric(12)
  end
end
