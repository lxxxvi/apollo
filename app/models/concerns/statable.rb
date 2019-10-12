module Statable
  extend ActiveSupport::Concern

  ALLOWED_TRANSITIONS = {
    drafted: %i[deleted published],
    published: %i[deleted started],
    started: %i[closed],
    closed: %i[archived],
    archived: [],
    deleted: []
  }.freeze

  INITIAL_STATE = :drafted

  # rubocop:disable Metrics/BlockLength
  included do
    scope :not_drafted, -> { where.not(published_at: nil) }
    scope :not_archived, -> { where(archived_at: nil) }
    scope :not_deleted, -> { where(deleted_at: nil) }

    validate :verified_user, unless: :drafted?

    def state
      return :deleted if deleted?
      return :archived if archived?
      return :closed if closed?
      return :started if started?
      return :published if published?

      INITIAL_STATE
    end

    def next_state
      return :published if drafted?
      return :started if published?
      return :closed if started?
      return :archived if closed?
    end

    def transit_to!(new_state)
      raise InvalidStateTransition.new(state, new_state) unless transition_allowed?(state, new_state)

      attributes = Hash[state_to_column[new_state], Time.zone.now]
      update!(attributes)
    end

    # state calculations

    def drafted?
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
      drafted? || published?
    end

    def deletable?
      transition_allowed?(state, :deleted)
    end

    private

    def state_to_column
      {
        published: :published_at,
        started: :started_at,
        closed: :closed_at,
        archived: :archived_at,
        deleted: :deleted_at
      }.with_indifferent_access
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
  end
  # rubocop:enable Metrics/BlockLength
end
