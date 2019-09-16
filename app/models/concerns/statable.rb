module Statable
  extend ActiveSupport::Concern

  ALLOWED_TRANSITIONS = {
    draft: %i[deleted published],
    published: %i[deleted started],
    started: %i[closed],
    closed: %i[archived],
    archived: [],
    deleted: []
  }.freeze

  # rubocop:disable Metrics/BlockLength
  included do
    scope :drafted, -> { where(published_at: nil) }
    scope :published, -> { where.not(published_at: nil) }
    scope :started, -> { where.not(started_at: nil) }
    scope :closed, -> { where.not(closed_at: nil) }
    scope :archived, -> { where.not(archived_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    def state
      return :deleted if deleted?
      return :archived if archived?
      return :closed if closed?
      return :started if started?
      return :published if published?

      :draft
    end

    def transition_allowed?(from_state, to_state)
      ALLOWED_TRANSITIONS[from_state].include?(to_state)
    end

    # state checks

    def draft?
      return false if deleted?

      published_at.nil?
    end

    def published?
      return false if deleted? || started? || closed? || archived?

      published_at.present?
    end

    def started?
      return false if closed? || archived?

      started_at.present?
    end

    def closed?
      return false if archived?

      closed_at.present?
    end

    def archived?
      archived_at.present?
    end

    def deleted?
      deleted_at.present?
    end

    # abilities

    def editable?
      draft? || published?
    end

    def publishable?
      transition_allowed?(state, :published) && user.verified?
    end

    def startable?
      transition_allowed?(state, :started)
    end

    def closable?
      transition_allowed?(state, :closed)
    end

    def archivable?
      transition_allowed?(state, :archived)
    end

    def deletable?
      transition_allowed?(state, :deleted)
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

    def close!
      raise Error::PollStateChangeError, 'Cannot close poll' unless closable?

      update!(closed_at: Time.zone.now)
    end

    def archive!
      raise Error::PollStateChangeError, 'Cannot archive poll' unless archivable?

      update!(archived_at: Time.zone.now)
    end

    def delete!
      raise Error::PollStateChangeError, 'Cannot delete poll' unless deletable?

      update!(deleted_at: Time.zone.now)
    end
  end
  # rubocop:enable Metrics/BlockLength
end
