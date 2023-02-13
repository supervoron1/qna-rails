require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { AnswerMailer.new_answer(answer, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have new answer on subscribed question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with new answer" do
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end