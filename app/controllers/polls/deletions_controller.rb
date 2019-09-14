class Polls::DeletionsController < ApplicationController
  def create
    poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollDeletionForm.new(poll)

    if form.save!
      redirect_to home_path, notice: 'Poll deleted'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to poll
    end
  end
end
