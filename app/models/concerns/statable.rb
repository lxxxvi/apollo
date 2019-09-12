module Statable
  extend ActiveSupport::Concern

  included do
    scope :drafted, -> { where(published_at: nil) }
    scope :published, -> { where.not(published_at: nil) }
    scope :started, -> { where.not(started_at: nil) }

    def state
      return :started if started?
      return :published if published?

      :draft
    end

    # state checks

    def draft?
      !published?
    end

    def published?
      published_at.present?
    end

    def started?
      started_at.present?
    end

    # abilities

    def publishable?
      draft? && user.verified?
    end

    def startable?
      published?
    end

    # actions

    def publish!
      raise Error::PollStateChangeError, 'Cannot publish poll' unless publishable?

      update!(published_at: Time.zone.now)
    end

    def start!
      raise Error::PollStateChangeError, 'Cannot start poll' unless startable?

      update!(started_at: Time.zone.now)
    end
  end
end
