class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  def index
    authorize Poll

    @polls = Poll.ordered
  end

  def show
    authorize @poll
  end

  def new
    @poll = Poll.new
    authorize @poll
  end

  def create
    @poll = Poll.new(new_poll_params)
    authorize @poll

    if @poll.save
      redirect_to poll_path(@poll)
    else
      render :new
    end
  end

  def edit
    authorize @poll
  end

  def update
    authorize @poll

    if @poll.update(edit_poll_params)
      redirect_to poll_path(@poll)
    else
      render :edit
    end
  end

  def destroy
    authorize @poll

    @poll.destroy
    redirect_to root_path
  end

  private

  def set_poll
    @poll = Poll.find_by!(custom_id: params[:custom_id])
  end

  def new_poll_params
    params.require(:poll).permit(:title, :email, :description)
  end

  def edit_poll_params
    params.require(:poll).permit(:title, :description)
  end
end
