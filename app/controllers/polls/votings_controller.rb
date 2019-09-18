class Polls::VotingsController < ApplicationController
  def create
    @poll = policy_scope(Poll).started.find_by!(custom_id: params[:poll_custom_id])

    form = PollVotingForm.new(@poll, poll_voting_params)

    # TODO: Improve me
    if form.save!
      redirect_to vote_poll_path(form.poll, form.token.value)
    else
      redirect_to vote_poll_path(form.poll, form.token.value)
    end
  end

  private

  def poll_voting_params
    params.require(:poll_voting).permit(:token_value, :nominee_id)
  end
end
