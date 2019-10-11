class InvalidStateTransition < StandardError
  def initialize(from_state, to_state)
    msg = "State transition from #{from_state} to #{to_state} is not allowed"

    super msg
  end
end
