class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_one :reward, dependent: :destroy
  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :notify_questions_author

  def mark_as_best!
    question.update(best_answer: self)
    question.reward.update(answer: self) if question.reward
  end

  def best?
    question.best_answer_id == id
  end

  private

  def notify_questions_author
    AnswerNotifyJob.perform_later(self)
  end
end
