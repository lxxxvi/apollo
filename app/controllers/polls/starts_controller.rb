class Polls::StartsController < ApplicationController
  def create
    poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])

    authorize poll, :manage?

    form = PollStartForm.new(poll)

    if form.save!
      redirect_to poll
    else
      redirect_to poll, error: form.errors.join
    end
  end
end
