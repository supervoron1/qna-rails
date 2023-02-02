class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[create destroy]

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

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end