class AnswerMailer < ApplicationMailer
  def new_answer(answer)
    @answer = answer
    @question = answer.question
    email = @question.user.email

    mail(to: email, subject: 'You have new answer on your question')
  end
end
