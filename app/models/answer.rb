class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_one :reward, dependent: :destroy
  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def mark_as_best!
    question.update(best_answer: self)
  end

  def best?
    question.best_answer_id == id
  end
end
