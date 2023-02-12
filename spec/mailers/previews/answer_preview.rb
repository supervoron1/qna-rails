# Preview all emails at http://localhost:3000/rails/mailers/answer
class AnswerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer/new_answer
  def new_answer
    AnswerMailer.new_answer
  end

end
