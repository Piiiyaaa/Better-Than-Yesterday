class AnswerRecord < ApplicationRecord
  belongs_to :user
  
  validates :total_challenge, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_correct, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :correct_rate, presence: true, numericality: { in: 0..100 }
  validates :user_id, uniqueness: true
  
  # 正解率を自動計算・更新
  def update_correct_rate!
    self.correct_rate = total_challenge > 0 ? (total_correct.to_f / total_challenge * 100).round(2) : 0.0
    save!
  end
  
  # チャレンジ回数と正解数を更新
  def increment_challenge!(is_correct)
    self.total_challenge += 1
    self.total_correct += 1 if is_correct
    update_correct_rate!
  end
 end