class Relationship < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followed, class_name: 'User'
  
    validates :follower_id, presence: true
    validates :followed_id, presence: true
    validate :not_self_follow
    
    private
    
    def not_self_follow
      if follower_id == followed_id
        errors.add(:followed_id, :not_self_follow)
      end
    end
  end