require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '全ての属性が正しい場合、有効である' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'ユーザーネームがないときにバリデーションが機能してinvalidになるか' do
      user_without_username = build(:user, username: "")
      expect(user_without_username).to be_invalid
      expect(user_without_username.errors[:username]).not_to be_empty
    end

    it 'ユーザーネームが10文字を超えるときにバリデーションが機能してinvalidになるか' do
      user_with_long_username = build(:user, username: 'a' * 11)
      expect(user_with_long_username).to be_invalid
      expect(user_with_long_username.errors[:username]).not_to be_empty
    end
  end

  describe 'アソシエーション' do
    it 'answer_recordが自動作成される' do
      user = create(:user)
      expect(user.answer_record).to be_present
      expect(user.answer_record.total_challenge).to eq(0)
    end
  end

  describe 'フォロー機能' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it 'ユーザーをフォローできる' do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      expect(other_user.followers).to include(user)
    end

    it 'ユーザーのフォローを解除できる' do
      user.follow(other_user)
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsy
    end

    it '自分自身はフォローできない' do
      expect { user.follow(user) }.not_to change { user.following.count }
    end
  end

  describe 'いいね機能' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it '投稿にいいねできる' do
      user.like(post)
      expect(user.like?(post)).to be_truthy
    end

    it '投稿のいいねを取り消せる' do
      user.like(post)
      user.unlike(post)
      expect(user.like?(post)).to be_falsy
    end
  end
end
