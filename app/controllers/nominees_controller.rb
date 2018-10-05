class NomineesController < ApplicationController
  def new
    @nominee = find_poll.nominees.new
  end

  def create
    poll = find_poll
    @nominee = poll.nominees.new(nominee_params)

    if @nominee.save
      redirect_to poll
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @nominee = find_nominee
  end

  def update
    @nominee = find_nominee

    if @nominee.update!(nominee_params)
      redirect_to @nominee.poll
    else
      render :edit
    end
  end

  private

  def nominee_params
    params.require(:nominee).permit(:name, :description)
  end

  def find_poll
    Poll.find_by!(custom_id: params[:poll_custom_id])
  end

  def find_nominee
    find_poll.nominees.find_by!(custom_id: params[:custom_id])
  end
end
