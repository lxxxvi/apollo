module Poll::States
  include Draft
  include Published

  def state
    find_state::NAME
  end

  private

  def find_state
    return Published if published?

    Draft
  end
end
