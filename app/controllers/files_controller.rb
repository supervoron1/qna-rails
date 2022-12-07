class FilesController < ApplicationController
  before_action :find_attachment
  before_action :get_entity
  before_action :check_owner

  def destroy
    @attachment.purge
    redirect_to @url, notice: 'Attachment was successfully deleted'
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def check_owner
    redirect_to @url, notice: "You can't delete someone else's attachment" unless current_user.author_of?(@attachment.record)
  end

  def get_entity
    @url = @attachment.record.question if @attachment.record.is_a?(Answer)
    @url = @attachment.record if @attachment.record.is_a?(Question)
  end
end
