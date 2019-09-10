module Error
  class PollStateChangeError < StandardError
    def initialize(msg)
      super msg
    end
  end
end
