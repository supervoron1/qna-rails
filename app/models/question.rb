class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, required: false, class_name: 'Answer', dependent: :destroy, optional: true

  validates :title, :body, presence: true
end
