class QuestionsController < ApplicationController
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]
  before_action :authorize_question, only: %i[show update destroy]

  after_action :publish_question, only: %i[create]

  include Voted

  def index
    @questions = Question.all

    authorize @questions
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new

    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.create(question_params)
    authorize @question

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     reward_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions',
                                 ApplicationController.render(
                                    # partial: 'questions/question',
                                    # locals: { question: @question },
                                    json: @question.title
                                 )

  end

  def authorize_question
    authorize @question
  end
end
