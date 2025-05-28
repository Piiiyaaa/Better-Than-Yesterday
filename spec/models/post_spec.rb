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

        it '本文がないときにバリデーションが機能してinvalidになるか' do
            post_without_body = build(:post, body: "")
            expect(post_without_body).to be_invalid
            expect(post_without_body.errors[:body]).not_to be_empty
          end
      
          it '学習日がないときにバリデーションが機能してinvalidになるか' do
            post_without_learning_date = build(:post, learning_date: nil)
            expect(post_without_learning_date).to be_invalid
            expect(post_without_learning_date.errors[:learning_date]).not_to be_empty
          end
    end

    describe 'タグ機能' do
        let(:post) { create(:post) }
    
        it 'タグを設定できる' do
          tag_names = ['Ruby', 'Rails']
          expect(post.save_with_tags(tag_names: tag_names)).to be_truthy
          expect(post.tags.map(&:name)).to match_array(tag_names)
        end
    
        it 'タグ名の文字列から配列に変換できる' do
          post.tag_names = 'Ruby,Rails,JavaScript'
          expect(post.tags.map(&:name)).to match_array(['Ruby', 'Rails', 'JavaScript'])
        end
      end
    
      describe 'いいね機能' do
        let(:post) { create(:post) }
        let(:user) { create(:user) }
    
        it 'ユーザーがいいねしているかチェックできる' do
          expect(post.liked_by?(user)).to be_falsy
          create(:like, user: user, post: post)
          expect(post.liked_by?(user)).to be_truthy
        end
      end
end
    