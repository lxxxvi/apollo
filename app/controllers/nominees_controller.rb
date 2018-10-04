class NomineesController < ApplicationController
  before_action :set_poll

  def new
    @nominee = @poll.nominees.new
  end

  def create
    @nominee = @poll.nominees.new(nominee_params)

    if @nominee.save
      redirect_to @poll
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def nominee_params
    params.require(:nominee).permit(:name, :description)
  end

  def set_poll
    @poll = Poll.find_by!(custom_id: params[:poll_custom_id])
  end
end
