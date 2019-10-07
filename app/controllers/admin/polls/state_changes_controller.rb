class Admin::Polls::StateChangesController < ApplicationController
  before_action :authorize_poll_and_set_form, only: :create

  def create
    if @form.save
      handle_success
    else
      flash[:error] = @form.errors.full_messages.join
      redirect_to admin_poll_path(@form.poll)
    end
  end

  private

  def admin_poll_state_change_params
    params.require(:admin_poll_state_change).permit(:next_state)
  end

  def handle_success
    return redirect_to polls_path if @form.poll.deleted?

    redirect_to admin_poll_path(@form.poll)
  end

  def authorize_poll_and_set_form
    poll = Poll.find_by!(custom_id: params[:poll_custom_id])
    authorize poll, :admin?

    @form = Admin::PollStateChangeForm.new(poll, admin_poll_state_change_params)
  end
end
