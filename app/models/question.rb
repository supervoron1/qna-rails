class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, required: false, class_name: 'Answer', dependent: :destroy, optional: true

  validates :title, :body, presence: true

  def not_best_answers
    self.answers.where.not(id: self.best_answer_id)
  end
end
