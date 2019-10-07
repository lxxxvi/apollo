class Admin::Polls::TokensController < ApplicationController
  before_action :set_poll
  before_action :set_token, only: :show

  def index; end

  def new
    authorize @poll, :update?

    @form = PollTokensForm.new(@poll)
  end

  def show
    authorize @poll, :show_token?
  end

  def create
    authorize @poll, :update?

    @form = PollTokensForm.new(@poll, poll_token_params)

    if @form.save
      redirect_to admin_poll_tokens_path(@poll)
    else
      render :new
    end
  end

  private

  def poll_token_params
    params.require(:poll_token).permit(:amount)
  end

  def set_poll
    @poll = policy_scope(Poll).find_by!(custom_id: params[:poll_custom_id])
  end

  def set_token
    @token = @poll.tokens.find_by!(value: params[:custom_id])
  end
end
