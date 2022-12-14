module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_votable, only: %i[like dislike cancel]
  end

  def like
    vote = @votable.votes.build(value: 1, user: current_user)

    respond_to do |format|
      if current_user.able_to_vote?(@votable) && vote.save
        format.json do
          render json: [rating: @votable.rating,
                        id: @votable.id]
        end
      else
        format.json do
          render json: vote.errors.full_messages,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def dislike
    vote = @votable.votes.build(value: -1, user: current_user)

    respond_to do |format|
      if current_user.able_to_vote?(@votable) && vote.save
        format.json do
          render json: [rating: @votable.rating,
                        id: @votable.id]
        end
      else
        format.json do
          render json: vote.errors.full_messages,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def cancel
    vote = @votable.votes.find_by(user: current_user)

    if vote.nil?
      respond_to do |format|
        format.json do
          render json: 'Not found',
                 status: :not_found
        end
      end and return
    end

    respond_to do |format|
      if current_user.able_to_cancel_vote?(@votable) && vote.destroy
        format.json do
          render json: [rating: @votable.rating,
                        id: @votable.id]
        end
      else
        format.json do
          render json: vote.errors.full_messages,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end