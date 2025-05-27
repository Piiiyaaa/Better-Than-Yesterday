class DailyQuestion < ApplicationRecord
  belongs_to :post

  validates :body, presence: true, length: { maximum: 400 }
  validates :question_answer, presence: true, length: { maximum: 400 }
  has_many :answers, dependent: :destroy
  has_many :answered_users, through: :answers, source: :user

  enum question_type: {
    description: 0,     # 記述式
    multiple_choice: 1, # 選択式
    fill_in_blank: 2    # 穴埋め式
  }

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

  def question_type_name
    case question_type
    when "description"
      "記述式"
    when "multiple_choice"
      "選択式"
    when "fill_in_blank"
      "穴埋め式"
    end
  end
end
