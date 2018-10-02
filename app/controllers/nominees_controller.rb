class NomineesController < ApplicationController
  before_action :set_poll

  def new
    @nominee = @poll.nominees.new
  end

  private

  def set_poll
    @poll = Poll.find_by!(custom_id: params[:poll_custom_id])
  end
end
