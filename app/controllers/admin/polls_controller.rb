class Admin::PollsController < ApplicationController
  before_action :set_poll, only: [:show, :manage, :update]

  def index
    authorize Poll

    @polls = policy_scope(Poll).ordered
  end

  # def show
  #   authorize @poll
  # end

  def update
    authorize @poll
    @form = PollForm.new(@poll, poll_params)

    if @form.save
      redirect_to manage_admin_poll_path(@form.poll)
    else
      render :manage
    end
  end

  # def manage
  #   authorize @poll
  # end

  private

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:custom_id])
  end

  def poll_params
    params.require(:poll).permit(:title, :description)
  end
end
