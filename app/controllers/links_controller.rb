class LinksController < ApplicationController
  before_action :find_link, only: %i[destroy]

  def destroy
    authorize @link
    @link.destroy
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
