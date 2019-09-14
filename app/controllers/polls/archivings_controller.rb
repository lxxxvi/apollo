class Polls::ArchivingsController < ApplicationController
  def create
    poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollArchivingForm.new(poll)

    if form.save!
      redirect_to poll, notice: 'Poll archived'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to poll
    end
  end
end
