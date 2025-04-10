class Post < ApplicationRecord
    belongs_to :user
    has_one :daily_question, dependent: :destroy
    has_one_attached :image
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user

    accepts_nested_attributes_for :daily_question
    
    validates :title, presence: true, length: { maximum: 20 }
    validates :body, presence: true, length: { maximum: 400 }
    validates :learning_date, presence: true

    def liked_by?(user)
      likes.exists?(user_id: user.id)
    end

    private

    def image_type_validation
      if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image])
        errors.add(:image, "はJPEG、PNGでアップロードしてください")
      end
    end

    def image_size
      if image.attached? && image.blob.byte_size > 1.megabytes
        errors.add(:image, "：1MB以下のファイルをアップロードしてください")
      end
    end
  end