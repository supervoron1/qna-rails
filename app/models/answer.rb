class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best!
    question.update(best_answer: self)
  end

  def best?
    question.best_answer_id == id
  end
end
