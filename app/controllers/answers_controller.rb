class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :check_owner, only: %i[edit update destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = current_user.answers.create(answer_params)
    @answer.assign_attributes(question: @question)

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question), notice: 'Your answer was successfully edited.'
    else
      render :edit
    end
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
