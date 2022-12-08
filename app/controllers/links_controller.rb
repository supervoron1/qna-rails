class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link, only: %i[destroy]
  before_action :check_owner, only: %i[destroy]

  def destroy
    @link.destroy
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end

  def check_owner
    redirect_to question_path(@link.linkable), alert: "You can't edit/delete someone else's link" unless current_user.author_of?(@link.linkable)
  end
end
