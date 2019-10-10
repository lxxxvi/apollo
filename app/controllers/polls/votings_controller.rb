class Polls::VotingsController < ApplicationController
  before_action :set_poll, only: %i[new create]
  before_action :set_token, only: %i[new create]

  def new
    token_policy = Pundit.policy(current_user, @token)

    if token_policy.legit?
      @token.mark_first_visit!
      @form = PollVotingForm.new(@token)
    else
      redirect_to poll_path(@poll)
    end
  end

  def create
    authorize @token, :legit?

    @form = PollVotingForm.new(@token, poll_voting_params)

    if @form.save!
      redirect_to poll_path(@poll), notice: 'Thank you for your vote!'
    else
      render :new
    end
  end

  private

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])
  end

  def set_token
    @token = @poll.tokens.find_by!(value: find_token_value)
  end

  def find_token_value
    params.dig(:poll_voting, :token_value) || params[:token_value]
  end

  def poll_voting_params
    params.require(:poll_voting).permit(:token_value, :nominee_id)
  end
end
