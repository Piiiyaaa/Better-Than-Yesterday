require 'rails_helper'

RSpec.describe Post, type: :model do
    describe 'バリデーションチェック' do
        it '設定したすべてのバリデーションが機能しているか' do
            post = build(:post, :with_image)
            expect(post).to be_valid
        end

        it 'タイトルがないときにバリデーションが機能してinvalidになるか' do
            post_without_title = build(:post, title: "")
            expect(post_without_title).to be_invalid
            expect(post_without_title.errors[:title]).not_to be_empty
        end

        it 'タイトルが20文字を超えるとinvalidになるか' do
            post_with_long_title = build(:post, title: "a" * 21)
            expect(post_with_long_title).to be_invalid
            expect(post_with_long_title.errors[:title]).not_to be_empty
        end
    end
end
