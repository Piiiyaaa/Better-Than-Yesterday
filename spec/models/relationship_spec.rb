require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'バリデーション' do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    it '有効なフォロー関係を作成できる' do
      relationship = build(:relationship, follower: follower, followed: followed)
      expect(relationship).to be_valid
    end

    it 'follower_idがないときにバリデーションが機能してinvalidになるか' do
      relationship_without_follower = build(:relationship, follower_id: nil, followed: followed)
      expect(relationship_without_follower).to be_invalid
      expect(relationship_without_follower.errors[:follower_id]).not_to be_empty
    end

    it 'followed_idがないときにバリデーションが機能してinvalidになるか' do
      relationship_without_followed = build(:relationship, follower: follower, followed_id: nil)
      expect(relationship_without_followed).to be_invalid
      expect(relationship_without_followed.errors[:followed_id]).not_to be_empty
    end

    it '自分自身をフォローできない' do
      user = create(:user)
      relationship = build(:relationship, follower: user, followed: user)
      expect(relationship).to be_invalid
      expect(relationship.errors[:followed_id]).to be_present
    end
  end
end
