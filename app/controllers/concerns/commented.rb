module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_commentable, only: %i[comment]

    after_action :publish_comment, only: %i[comment]
  end

  def comment
    @comment = @commentable.comments.new(commentable_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.json do
          render json: [comment: @comment]
        end
      else
        format.json do
          render json: [errors: @comment.errors.full_messages, comment: @comment],
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast 'comments', {
      comment: @comment.body,
      commentable_id: @comment.commentable_id,
      commentable_type: @comment.commentable_type,
      user_id: @comment.user_id
    }
  end
end