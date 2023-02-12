class AnswerMailer < ApplicationMailer
  def new_answer(answer, user)
    @answer = answer
    @question = answer.question

    mail(to: user.email, subject: 'You have new answer on subscribed question')
  end
end
