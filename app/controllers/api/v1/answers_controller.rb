class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy]

  skip_before_action :verify_authenticity_token

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.assign_attributes(question: @question)

    authorize @answer

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :bad_request
    end
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors: @answer.errors }, status: :bad_request
    end
  end

  def destroy
    authorize @answer

    @answer.destroy
    head :no_content
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end