class Post < ApplicationRecord
    belongs_to :user
    has_one :daily_question, dependent: :destroy
    has_one_attached :image
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    accepts_nested_attributes_for :daily_question

    validates :title, presence: true, length: { maximum: 20 }
    validates :body, presence: true, length: { maximum: 400 }
    validates :learning_date, presence: true

    def liked_by?(user)
      likes.exists?(user_id: user.id)
    end

    def save_with_tags(tag_names:)
      ActiveRecord::Base.transaction do
        self.tags = tag_names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
        save!
      end
      true
    rescue StandardError
      false
    end

    def tag_names
      tags.map(&:name).join(",")
    end

    def tag_names=(names)
      return if names.blank?
      tag_names_array = names.split(",").map(&:strip).reject(&:blank?).uniq
      tag_objects = tag_names_array.map do |tag_name|
        Tag.find_or_create_by(name: tag_name)
      end

      self.tags = tag_objects
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
