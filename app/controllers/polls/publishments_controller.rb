class Polls::PublishmentsController < ApplicationController
  def create
    poll = Poll.find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollPublishmentForm.new(poll)

    if form.save!
      redirect_to poll
    else
      redirect_to poll, error: form.errors.full_messages.join
    end
  end
end
