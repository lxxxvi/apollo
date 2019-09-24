class Admin::Polls::PublishmentsController < ApplicationController
  def create
    poll = Poll.find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollPublishmentForm.new(poll)

    if form.save!
      redirect_to admin_poll_path(poll), notice: 'Poll published'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to admin_poll_path(poll)
    end
  end
end
