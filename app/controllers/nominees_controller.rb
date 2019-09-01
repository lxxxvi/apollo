class NomineesController < ApplicationController
  before_action :set_poll

  def new
    authorize @poll, :manage?

    @nominee = @poll.nominees.new
  end

  def create
    authorize @poll, :manage?

    @nominee = @poll.nominees.new(nominee_params)

    if @nominee.save
      redirect_to @poll
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @poll, :manage?

    @nominee = find_nominee
  end

  def update
    authorize @poll, :manage?

    @nominee = find_nominee

    if @nominee.update!(nominee_params)
      redirect_to @nominee.poll
    else
      render :edit
    end
  end

  def destroy
    authorize @poll, :manage?

    @nominee = find_nominee
    @nominee.destroy
    redirect_to @nominee.poll
  end

  private

  def nominee_params
    params.require(:nominee).permit(:name, :description)
  end

  def set_poll
    @poll = Poll.find_by!(custom_id: params[:poll_custom_id])
  end

  def find_nominee
    @poll.nominees.find_by!(custom_id: params[:custom_id])
  end
end
