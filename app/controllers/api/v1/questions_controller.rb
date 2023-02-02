class Api::V1::QuestionsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    authorize @question

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :bad_request
    end
  end

  def answers
    @answers = Question.find(params[:id]).answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end