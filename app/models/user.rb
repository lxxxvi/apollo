class User < ApplicationRecord
  has_many :polls, dependent: :destroy

  after_initialize :create_authentication_token

  validates :email, presence: true

  private

  def create_authentication_token
    self.authentication_token ||= SecureRandom.alphanumeric(12)
    self.authentication_token_expires_at ||= Time.zone.now
  end
end
