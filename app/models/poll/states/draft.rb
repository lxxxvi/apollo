module Poll::States::Draft
  NAME = :draft

  def draft?
    published_at.nil?
  end
end
