class Admin::Polls::ArchivingsController < ApplicationController
  before_action :set_poll, only: %i[create]

  def create
    authorize @poll, :manage?

    form = PollArchivingForm.new(@poll)

    if form.save!
      redirect_to admin_poll_path(@poll), notice: 'Poll archived'
    else
      flash[:error] = form.errors.full_messages.join
      redirect_to admin_poll_path(@poll)
    end
  end

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])
  end
end
