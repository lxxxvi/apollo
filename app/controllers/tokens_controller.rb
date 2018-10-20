class TokensController < ApplicationController
  def create
    poll = find_poll

    poll.tokens.create
    redirect_to poll
  end

  private

  def find_poll
    Poll.find_by!(custom_id: params[:poll_custom_id])
  end
end
