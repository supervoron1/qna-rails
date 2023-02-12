class AnswerNotify
  def send_notify(answer)
    AnswerMailer.new_answer(answer).deliver_later
  end
end