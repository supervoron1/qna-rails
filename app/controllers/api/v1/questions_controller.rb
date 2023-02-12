class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
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

  def update
    authorize @question

    if @question.update(question_params)
      head :ok
    else
      render json: { errors: @question.errors }, status: :bad_request
    end
  end

  def destroy
    authorize @question

    @question.destroy
    head :no_content
  end

  def answers
    @answers = Question.find(params[:id]).answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end