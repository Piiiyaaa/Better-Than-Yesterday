class User < ApplicationRecord
  after_create :build_answer_record!

  validates :username, presence: true, length: { maximum: 10 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :answers, dependent: :destroy
  has_one :answer_record, dependent: :destroy

  def like(post)
    liked_posts << post unless like?(post)
  end

  def unlike(post)
    liked_posts.delete(post)
  end

  def like?(post)
    liked_posts.include?(post)
  end

  def answered_question?(daily_question)
    answers.exists?(daily_question: daily_question)
  end
  
  def overall_correct_rate
    return 0.0 if answers.count == 0
    (answers.correct.count.to_f / answers.count * 100).round(2)
  end
  
  def daily_answer_stats
    Answer.daily_stats_for_user(self, 10)
  end
  
  def total_answers_count
    answers.count
  end
  
  def total_correct_count
    answers.correct.count
  end

  def build_answer_record!
    create_answer_record!(total_challenge: 0, total_correct: 0, correct_rate: 0.0)
  end

end
