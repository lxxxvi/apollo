class PollsController < ApplicationController
  def show
    @poll = Poll.new
  end

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

  def poll_params
    params.require(:poll).permit(:title, :email, :description)
  end
end
