class FilesController < ApplicationController
  before_action :find_record
  before_action :check_owner

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user.author_of?(@record)
    redirect_to @attachment.record, notice: 'Attachment was successfully deleted'
  end

  private

  def find_record
    @record = ActiveStorage::Attachment.find(params[:id]).record
  end

  def check_owner
    redirect_to @record, alert: "You can't delete someone else's attachment" unless current_user.author_of?(@record)
  end
end
