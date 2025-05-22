class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :daily_question
  
  validates :user_id, uniqueness: { scope: :daily_question_id, message: "この問題にはすでに回答済みです" }
  validates :is_correct, inclusion: { in: [true, false] }
  
  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }
  scope :on_date, ->(date) { where(created_at: date.beginning_of_day..date.end_of_day) }
  
  # 日毎の正答率データ（過去10日分）
  def self.daily_stats_for_user(user, days = 10)
    (0...days).map do |i|
      date = i.days.ago.to_date
      answers = on_date(date).where(user: user)
      
      {
        date: date.strftime('%m/%d'),
        correct_count: answers.correct.count,
        total_count: answers.count,
        correct_rate: answers.count > 0 ? (answers.correct.count.to_f / answers.count * 100).round(1) : 0.0
      }
    end.reverse
  end
end
