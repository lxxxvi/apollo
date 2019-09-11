module Statable
  extend ActiveSupport::Concern

  included do
    scope :drafted, -> { where(published_at: nil) }
    scope :published, -> { where.not(published_at: nil) }

    def state
      return :published if published?

      :draft
    end

    def draft?
      published_at.nil?
    end

    def published?
      published_at.present?
    end

    def unpublished?
      !published?
    end

    def publishable?
      unpublished? && user.verified?
    end

    def publish!
      raise Error::PollStateChangeError, 'Cannot publish poll' unless publishable?

      update!(published_at: Time.zone.now)
    end
  end
end
