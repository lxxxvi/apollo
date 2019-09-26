class Admin::PollsController < ApplicationController
  before_action :set_poll, only: %i[show update]

  def show
    authorize @poll, :admin?
  end

  def update
    authorize @poll
    @form = PollForm.new(@poll, poll_params)

    if @form.save
      redirect_to admin_poll_path(@form.poll)
    else
      render :show
    end
  end

  private

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:custom_id])
  end

  def poll_params
    params.require(:poll).permit(:title, :description)
  end
end
