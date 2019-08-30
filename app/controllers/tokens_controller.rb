class TokensController < ApplicationController
  def new
    poll = find_poll

    @form = TokenForm.new(poll)
  end

  def create
    poll = find_poll

    @form = TokenForm.new(poll, poll_token_params)

    if @form.save
      redirect_to poll
    else
      render :new
    end
  end

  def destroy
    token = find_token
    token.destroy
    redirect_to token.poll
  end

  private

  def poll_token_params
    params.require(:poll_token).permit(:amount)
  end

  def find_poll
    Poll.find_by!(custom_id: params[:poll_custom_id])
  end

  def find_token
    find_poll.tokens.find_by!(value: params[:value])
  end
end
