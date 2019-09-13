class Polls::PublishmentsController < ApplicationController
  def create
    poll = Poll.find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollPublishmentForm.new(poll)

    if form.save!
      redirect_to poll, notice: 'Poll published'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to poll
    end
  end
end
