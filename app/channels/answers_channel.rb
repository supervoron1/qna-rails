class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers"
    # stream_from "answers/#{params[:question_id]}"
  end
end