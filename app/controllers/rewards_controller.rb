class RewardsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @rewards = current_user.rewards
  end
end
