class Admin::PollsController < ApplicationController
  before_action :set_poll, only: %i[show update]

  def index
    authorize Poll, :admin_index?
    @polls = policy_scope(Poll).ordered
  end

  def show
    authorize @poll, :admin?

    @admin_poll_form = Admin::PollForm.new(@poll)
    @admin_poll_schedule_form = Admin::PollScheduleForm.new(@poll)
  end

  def update
    authorize @poll

    return handle_poll_schedule_form if poll_schedule_form?

    handle_poll_form
  end

  private

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:custom_id])
  end

  def poll_schedule_form?
    params[Admin::PollScheduleForm::NAME].present?
  end

  def handle_poll_form
    @admin_poll_form = Admin::PollForm.new(@poll, poll_params)

    if @admin_poll_form.save
      redirect_to admin_poll_path(@admin_poll_form.poll), notice: 'Poll has been updated'
    else
      render :show
    end
  end

  def poll_params
    params.require(:admin_poll).permit(:title, :description)
  end

  def handle_poll_schedule_form
    @admin_poll_schedule_form = Admin::PollScheduleForm.new(@poll, poll_schedule_params)

    if @admin_poll_schedule_form.save
      redirect_to admin_poll_path(@admin_poll_schedule_form.poll), notice: 'Poll schedule has been updated'
    else
      render :show
    end
  end

  def poll_schedule_params
    params.require(:admin_poll).permit(:time_zone, :started_at, :closed_at)
  end
end
