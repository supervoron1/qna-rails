require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { AnswerMailer.new_answer(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have new answer on your question")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with new answer" do
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end