require 'rails_helper'

RSpec.describe 'フォロー機能', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe 'フォロー・フォロー解除' do
    it 'ユーザーをフォローできる（投稿詳細ページから）' do
      # 投稿詳細ページでフォロー機能をテスト
      daily_question = create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え')
      post = create(:post, user: other_user, daily_question: daily_question)
      
      visit post_path(post)
      
      # フォローボタンがあることを確認
      expect(page).to have_button('フォローする')
      
      # Turboの処理を待つため、ページが安定するまで待機
      click_button 'フォローする'
      
      # Turbo Streamによる更新を待つ
      expect(page).to have_button('フォロー解除', wait: 5)
    end

    it 'ユーザーのフォローを解除できる（投稿詳細ページから）' do
      # 事前にフォローしておく
      user.follow(other_user)
      
      daily_question = create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え')
      post = create(:post, user: other_user, daily_question: daily_question)
      
      visit post_path(post)
      
      # フォロー解除ボタンがあることを確認
      expect(page).to have_button('フォロー解除')
      
      click_button 'フォロー解除'
      
      # Turbo Streamによる更新を待つ
      expect(page).to have_button('フォローする', wait: 5)
    end
  end

  describe 'フォロー関係の一覧表示' do
    it 'フォロワー一覧が表示される' do
      user.follow(other_user)
      
      visit user_profile_followers_path(other_user)
      
      # ページタイトルの確認
      expect(page).to have_text('フォローワー')
      
      # フォロワーとして表示される
      expect(page).to have_text(user.username)
      expect(page).to have_link(user.username, href: user_profile_path(user))
    end

    it 'フォロー中一覧が表示される' do
      user.follow(other_user)
      
      visit user_profile_followings_path(user)
      
      # ページタイトルの確認
      expect(page).to have_text('フォロー中のユーザー')
      
      # フォロー中として表示される
      expect(page).to have_text(other_user.username)
      expect(page).to have_link(other_user.username, href: user_profile_path(other_user))
    end

    it 'フォロワーがいない場合のメッセージが表示される' do
      visit user_profile_followers_path(user)
      
      # type='following' のため「フォローしているユーザーはいません」が表示される
      expect(page).to have_text('フォローしているユーザーはいません')
    end

    it 'フォロー中がいない場合のメッセージが表示される' do
      visit user_profile_followings_path(user)
      
      # type='followers' のため「フォロワーはいません」が表示される
      expect(page).to have_text('フォロワーはいません')
    end
  end

  describe 'プロフィール統計表示' do
    it 'フォロー数が正しく表示される' do
      # 複数のユーザーをフォロー
      user2 = create(:user)
      
      user.follow(other_user)
      user.follow(user2)
      
      visit user_profile_path(user)
      
      # フォロー中の数が表示される（_stats.html.erb）
      expect(page).to have_text('2')
      expect(page).to have_text('フォロー中')
      
      # フォロー中一覧へのリンクが機能する
      click_link href: user_profile_followings_path(user)
      expect(page).to have_current_path(user_profile_followings_path(user))
    end

    it 'フォロワー数が正しく表示される' do
      # 複数のユーザーからフォローされる
      user2 = create(:user)
      
      user.follow(other_user)
      user2.follow(other_user)
      
      visit user_profile_path(other_user)
      
      # フォロワー数が表示される（_stats.html.erb）
      expect(page).to have_text('2')
      expect(page).to have_text('フォロワー')
      
      # フォロワー一覧へのリンクが機能する
      click_link href: user_profile_followers_path(other_user)
      expect(page).to have_current_path(user_profile_followers_path(other_user))
    end
  end
end