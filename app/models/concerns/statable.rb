# rubocop:disable Metrics/ModuleLength
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

  INITIAL_STATE = :draft

  # rubocop:disable Metrics/BlockLength
  included do
    # scope :not_draft, -> { where.not(published_at: nil) }
    # scope :draft, -> { where(published_at: nil) }
    # scope :published, -> { where(started_at: nil) }
    # scope :started, -> { where(closed: nil) }
    # scope :closed, -> { where(archived: nil) }
    # scope :not_archived, -> { where.not(archived_at: nil) }
    # scope :archived, -> { where.not(archived_at: :archived) }
    # scope :deleted, -> { where.not(deleted_at: nil) }
    scope :not_deleted, -> { where(deleted_at: nil) }

    validate :verified_user, unless: :draft?

    def state
      return :deleted if deleted?
      return :archived if archived?
      return :closed if closed?
      return :started if started?
      return :published if published?

      INITIAL_STATE
    end

    def next_state
      return :published if draft?
      return :started if published?
      return :closed if started?
      return :archived if closed?
    end

    def state_to_column
      {
        published: :published_at,
        started: :started_at,
        closed: :closed_at,
        archived: :archived_at,
        deleted: :deleted_at
      }.with_indifferent_access
    end

    def transit_to!(new_state)
      if transition_allowed?(state, new_state)
        attributes = Hash[state_to_column[new_state], Time.zone.now]
        update!(attributes)
      else
        raise InvalidStateTransition.new(state, new_state)
      end
    end

    def verified_user
      return if user.verified?

      errors.add(:user, 'must be verified')
    end

    def transition_allowed?(from_state, to_state)
      (to_state.to_sym == INITIAL_STATE) ||
        (from_state == to_state) ||
        ALLOWED_TRANSITIONS[from_state.to_sym].include?(to_state.to_sym)
    end

    # state calculations

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

    def deletable?
      transition_allowed?(state, :deleted)
    end

    # # actions
    # def published!
    #   self.published_at = Time.zone.now
    # end

    # def started!
    #   self.started_at = Time.zone.now
    # end

    # def closed!
    #   self.closed_at = Time.zone.now
    # end

    # def archived!
    #   self.archived_at = Time.zone.now
    # end

    # def deleted!
    #   self.deleted_at = Time.zone.now
    # end
  end
  # rubocop:enable Metrics/BlockLength
end
# rubocop:enable Metrics/ModuleLength
