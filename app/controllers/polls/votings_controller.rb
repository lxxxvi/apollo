class Polls::VotingsController < ApplicationController
  before_action :set_poll_and_token, only: %i[new create]

  def new
    authorize @poll, :vote?

    @form =  PollVotingForm.new(@token)
  end

  def create
    authorize @poll, :vote?

    @form = PollVotingForm.new(@token, poll_voting_params)

    if @form.save!
      redirect_to poll_path(@poll)
    else
      render :new
    end
  end

  private

  def set_poll_and_token
    @poll = policy_scope(Poll).started.find_by!(custom_id: params[:poll_custom_id])
    @token = @poll.tokens.unused.find_by!(value: find_token_value)
  end

  def find_token_value
    params.dig(:poll_voting, :token_value) || params[:token_value]
  end

  def poll_voting_params
    params.require(:poll_voting).permit(:token_value, :nominee_id)
  end
end
