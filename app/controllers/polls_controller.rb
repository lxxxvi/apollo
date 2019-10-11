class PollsController < ApplicationController
  def index
    @polls = policy_scope(Poll).ordered
  end

  def show
    @poll = policy_scope(Poll).find_by!(custom_id: params[:custom_id])
  end

  def new
    poll = Poll.new
    authorize poll

    @form = PollForm.new(poll)
  end

  def create
    poll = Poll.new
    authorize poll

    @form = PollForm.new(poll, poll_params)

    if @form.save
      sign_in @form.poll.user
      redirect_to poll_path(@form.poll)
    else
      render :new
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:title, :email, :description)
  end
end
