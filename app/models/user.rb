class User < ApplicationRecord
  after_create :build_answer_record!

  validates :username, presence: true, length: { maximum: 10 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :answers, dependent: :destroy
  has_one :answer_record, dependent: :destroy

  has_many :active_relationships, 
    class_name: 'Relationship',
    foreign_key: 'follower_id',
    dependent: :destroy
  has_many :passive_relationships, 
    class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy
  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

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

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.username = generate_username_from_google_name(auth.info.name, auth.info.email)
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def follow(other_user)
    return if self == other_user # 自分自身はフォローできない
    active_relationships.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationship = active_relationships.find_by(followed_id: other_user.id)
    relationship&.destroy 
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

  def self.generate_username_from_google_name(name, email)
    # Googleの名前から10文字以内のユーザー名を生成
    base_username = if name.present?
                      # 日本語名の場合は姓名を結合、英語名の場合は最初の名前を使用
                      name.gsub(/\s+/, "").slice(0, 8)
                    else
                      email.split("@").first.slice(0, 8)
                    end

    username = base_username
    counter = 1

    # 重複チェック（10文字制限内で）
    while User.exists?(username: username)
      suffix = counter.to_s
      max_base_length = 10 - suffix.length
      username = "#{base_username.slice(0, max_base_length)}#{suffix}"
      counter += 1
    end

    username
  end
end