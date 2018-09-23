class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit]

  def show; end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)

    if @poll.save
      redirect_to poll_path(@poll)
    else
      render :new
    end
  end

  def edit
    # TODO
  end

  def update
    # TODO
  end

  def delete
    # TODO
  end

  private

  def set_poll
    @poll ||= Poll.find(params[:id])
  end

  def poll_params
    params.require(:poll).permit(:title, :email, :description)
  end
end
