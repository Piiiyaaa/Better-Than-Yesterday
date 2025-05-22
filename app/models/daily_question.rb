class DailyQuestion < ApplicationRecord
  belongs_to :post

  validates :body, presence: true, length: { maximum: 400 }
  validates :question_answer, presence: true, length: { maximum: 400 }
  has_many :answers, dependent: :destroy
  has_many :answered_users, through: :answers, source: :user
 
  # この問題の正答率
  def correct_rate
    return 0.0 if answers.count == 0
    (answers.correct.count.to_f / answers.count * 100).round(2)
  end
 
  # 回答数
  def answer_count
    answers.count
  end
  
  # 特定ユーザーの回答を取得
  def user_answer(user)
    answers.find_by(user: user)
  end
 end