class AnswerNotify
  def send_notify(answer)
    answer.question.subscriptions.map(&:user).each do |user|
      AnswerMailer.new_answer(answer, user).deliver_later
    end
  end
end