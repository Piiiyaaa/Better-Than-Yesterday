require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it '有効ないいねを作成できる' do
      like = build(:like, user: user, post: post)
      expect(like).to be_valid
    end

    it '同じユーザーが同じ投稿に重複いいねできないことをバリデーションでチェックする' do
      create(:like, user: user, post: post)
      duplicate_like = build(:like, user: user, post: post)
      expect(duplicate_like).to be_invalid
      expect(duplicate_like.errors[:user_id]).not_to be_empty
    end
  end
end