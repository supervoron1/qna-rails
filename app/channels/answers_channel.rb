class AnswersChannel < ApplicationCable::Channel
  def follow
    # stream_from "answers"
    # stream_from "answers/#{params[:question_id]}"
    stream_from "answers_channel_#{ params[:question_id] }"
  end
end