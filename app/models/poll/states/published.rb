module Poll::States::Published
  NAME = :published

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
