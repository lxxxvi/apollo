class Polls::TokensController < ApplicationController
  before_action :set_poll

  def new
    authorize @poll, :manage?

    @form = TokenForm.new(@poll)
  end

  def create
    authorize @poll, :manage?

    @form = TokenForm.new(@poll, poll_token_params)

    if @form.save
      redirect_to @poll
    else
      render :new
    end
  end

  def destroy
    authorize @poll, :manage?

    token = find_token
    token.destroy
    redirect_to token.poll
  end

  private

  def poll_token_params
    params.require(:poll_token).permit(:amount)
  end

  def set_poll
    @poll = Poll.find_by!(custom_id: params[:poll_custom_id])
  end

  def find_token
    @poll.tokens.find_by!(value: params[:value])
  end
end
