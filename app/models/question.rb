class Question < ApplicationRecord
  include Votable
  include Commentable

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  belongs_to :best_answer, required: false, class_name: 'Answer', dependent: :destroy, optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def not_best_answers
    self.answers.where.not(id: self.best_answer_id)
  end
end
