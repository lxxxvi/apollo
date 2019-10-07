class Admin::Polls::NomineesController < ApplicationController
  before_action :set_poll

  def new
    authorize @poll, :update?

    @nominee = @poll.nominees.new
  end

  def create
    authorize @poll, :update?

    @nominee = @poll.nominees.new(nominee_params)

    if @nominee.save
      redirect_to admin_poll_nominees_path(@poll)
    else
      render :new, state: :unprocessable_entity
    end
  end

  def edit
    authorize @poll, :update?

    @nominee = find_nominee
  end

  def update
    authorize @poll, :update?

    @nominee = find_nominee

    if @nominee.update!(nominee_params)
      redirect_to admin_poll_nominees_path(@nominee.poll)
    else
      render :edit
    end
  end

  def destroy
    authorize @poll, :update?

    @nominee = find_nominee
    @nominee.destroy
    redirect_to admin_poll_nominees_path(@nominee.poll)
  end

  private

  def nominee_params
    params.require(:nominee).permit(:name, :description)
  end

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])
  end

  def find_nominee
    @poll.nominees.find_by!(custom_id: params[:custom_id])
  end
end
