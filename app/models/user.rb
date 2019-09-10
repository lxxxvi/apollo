class User < ApplicationRecord
  AUTHENTICATION_TOKEN_VALIDITY_TIME = 1.week.freeze

  has_many :polls, dependent: :destroy

  after_initialize :initialize_authentication_token

  validates :email, presence: true

  scope :with_valid_authentication_tokens, -> {
    where('authentication_token_expires_at >= :datetime', datetime: Time.zone.now)
  }

  def refresh_authentication_token!
    update!(authentication_token: new_authentication_token,
            authentication_token_expires_at: new_authentication_token_expires_at)
  end

  def verified?
    email_verified_at.present?
  end

  private

  def initialize_authentication_token
    self.authentication_token ||= new_authentication_token
    self.authentication_token_expires_at ||= new_authentication_token_expires_at
  end

  def new_authentication_token
    SecureRandom.alphanumeric(12)
  end

  def new_authentication_token_expires_at
    AUTHENTICATION_TOKEN_VALIDITY_TIME.from_now
  end
end
