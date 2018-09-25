class HomeController < ApplicationController
  def show
    @polls = Poll.ordered
  end
end
