require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'バリデーション' do
    it '名前があれば有効である' do
      tag = build(:tag)
      expect(tag).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'postsとの関連付けが正しく動作する' do
      tag = create(:tag)
      post = create(:post)
      create(:tagging, tag: tag, post: post)
      expect(tag.posts).to include(post)
    end
  end
end
