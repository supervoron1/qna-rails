class DailyMailer < ApplicationMailer
  def digest(user)
    @new_questions = Question.where(created_at: Date.today.all_day)

    mail(to: user.email, subject: 'Daily digest of all new questions')
  end
end
