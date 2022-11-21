class FilesController < ApplicationController
  before_action :find_attachment
  before_action :check_owner

  def destroy
    @attachment.purge if current_user.author_of?(@attachment.record)
    redirect_to @attachment.record.question, notice: 'Attachment was successfully deleted' if @attachment.record.is_a?(Answer)
    redirect_to @attachment.record, notice: 'Attachment was successfully deleted' if @attachment.record.is_a?(Question)
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def check_owner
    unless current_user.author_of?(@attachment.record)
      redirect_to @attachment.record.question, notice: 'Attachment was successfully deleted' if @attachment.record.is_a?(Answer)
      redirect_to @attachment.record, notice: 'Attachment was successfully deleted' if @attachment.record.is_a?(Question)
    end
  end
end
