class Admin::Polls::DeletionsController < ApplicationController
  before_action :set_poll, only: %i[create]

  def create
    authorize @poll, :admin?

    form = Admin::PollDeletionForm.new(@poll)

    if form.save!
      redirect_to root_path, notice: 'Poll deleted'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to admin_poll_path(@poll)
    end
  end

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])
  end
end
