class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def author_of?(object)
    object.user_id == id
  end

  def rewards
    Reward.where(answer_id: answers)
  end

  def able_to_vote?(votable)
    !author_of?(votable) && votable.votes.pluck(:user_id).exclude?(id)
  end

  def able_to_cancel_vote?(votable)
    !author_of?(votable) && votable.votes.pluck(:user_id).include?(id)
  end
end
