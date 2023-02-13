class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def create
    @subscription = current_user.subscriptions.new(question: @question)
    authorize @subscription

    @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize @subscription

    @subscription.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
