class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy]
  before_action :check_owner, only: %i[update destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.assign_attributes(question: @question)
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_owner
    redirect_to question_path(@answer.question), alert: "You can't edit/delete someone else's answer" unless current_user.author_of?(@answer)
  end
end
