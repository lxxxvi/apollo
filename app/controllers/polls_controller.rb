class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :delete]

  def show; end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(new_poll_params)

    if @poll.save
      redirect_to poll_path(@poll)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @poll.update(edit_poll_params)
      redirect_to poll_path(@poll)
    else
      render :edit
    end
  end

  def delete
    # TODO
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
