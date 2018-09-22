class PollsController < ApplicationController
  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
  end

  def edit
    # TODO
  end

  def update
    # TODO
  end

  def delete
    # TODO
  end
end
