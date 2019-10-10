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
    scope :draft, -> { where(state: :draft) }
    scope :published, -> { where(state: :published) }
    scope :started, -> { where(state: :started) }
    scope :closed, -> { where(state: :closed) }
    scope :archived, -> { where(state: :archived) }
    scope :deleted, -> { where.not(deleted_at: nil) }
    scope :without_archived, -> { where.not(archived_at: nil) }
    scope :without_deleted, -> { where.not(deleted_at: nil) }
    scope :in_state, ->(states) { where(state: states) }

    before_validation :calculate_state

    validate :verified_user, unless: :draft?
    validate :state_transition

    def calculate_state
      return :deleted if deleted?
      return :archived if archived?
      return :closed if closed?
      return :started if started?
      return :published if published?

      INITIAL_STATE
    end

    def calculated_state
      self.state = calculate_state
    end

    def next_state
      return :published if draft?
      return :started if published?
      return :closed if started?
      return :archived if closed?
    end

    def transit_action
      {
        draft: -> { draft },
        published: -> { publish },
        started: -> { start },
        closed: -> { close },
        archived: -> { archive },
        deleted: -> { delete }
      }[state.to_sym]
    end

    def transit
      transit_action&.call
    end

    def state_transition
      return if transition_allowed?(state_was, state)

      errors.add(:base, "State transition from #{state_was} to #{state} is not allowed")
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

    # actions
    def draft
      update(state: :draft)
    end

    def publish
      update(published_at: Time.zone.now, state: :published)
    end

    def start
      update(started_at: Time.zone.now, state: :started)
    end

    def close
      update(closed_at: Time.zone.now, state: :closed)
    end

    def archive
      update(archived_at: Time.zone.now, state: :archived)
    end

    def delete
      update(deleted_at: Time.zone.now, state: :deleted)
    end
  end
  # rubocop:enable Metrics/BlockLength
end
# rubocop:enable Metrics/ModuleLength
