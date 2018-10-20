class TokensController < ApplicationController
  def create
    poll = find_poll

    poll.tokens.create
    redirect_to poll
  end

  def destroy
    token = find_token
    token.destroy
    redirect_to token.poll
  end

  private

  def find_poll
    Poll.find_by!(custom_id: params[:poll_custom_id])
  end

  def find_token
    find_poll.tokens.find_by!(value: params[:value])
  end
end
