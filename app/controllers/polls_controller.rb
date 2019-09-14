class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update]

  def index
    authorize Poll

    @polls = Poll.ordered
  end

  def show
    authorize @poll
  end

  def new
    poll = Poll.new
    authorize poll

    @form = PollForm.new(poll)
  end

  def create
    poll = Poll.new
    authorize poll

    @form = PollForm.new(poll, new_poll_params)

    if @form.save
      sign_in @form.poll.user
      redirect_to poll_path(@form.poll)
    else
      render :new
    end
  end

  def edit
    authorize @poll

    @form = PollForm.new(@poll, @poll.slice(:title, :description))
  end

  def update
    authorize @poll
    @form = PollForm.new(@poll, edit_poll_params)

    if @form.save
      redirect_to poll_path(@form.poll)
    else
      render :edit
    end
  end

  private

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:custom_id])
  end

  def new_poll_params
    params.require(:poll).permit(:title, :email, :description)
  end

  def edit_poll_params
    params.require(:poll).permit(:title, :description)
  end
end
