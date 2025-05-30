require 'rails_helper'

RSpec.describe 'Userテスト', type: :system do
  describe 'ユーザー登録フォーム' do
    it 'ユーザー登録フォームが表示される' do
      visit new_user_registration_path

      # フォームの存在確認
      expect(page).to have_field('user[username]')
      expect(page).to have_field('user[email]')
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')
      expect(page).to have_selector('input[type="submit"]')
    end

    it 'ユーザー登録ができる' do
      visit new_user_registration_path

      # 10文字以内の短いユーザー名を使用
      timestamp = Time.current.to_i.to_s[-6..-1] # 6桁の数字
      unique_email = "test#{timestamp}@example.com"
      unique_username = "user#{timestamp}" # 10文字以内

      fill_in 'user[username]', with: unique_username
      fill_in 'user[email]', with: unique_email
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'

      # CI環境では少し待機
      sleep 0.5 if ENV['CI'] == 'true'

      find('input[type="submit"]').click

      # 登録成功の確認（メッセージまたはページ遷移）
      expect(page).to have_content('アカウント作成が完了しました！', wait: 15)

      # データベースでもユーザーが作成されていることを確認
      expect(User.find_by(email: unique_email)).to be_present
    end
  end

  describe 'ログインフォーム' do
    let(:user) { create(:user) }

    it 'ログインフォームが表示される' do
      visit new_user_session_path

      expect(page).to have_field('user[email]')
      expect(page).to have_field('user[password]')
      expect(page).to have_selector('input[type="submit"]')
    end

    it 'ログインが実行できる' do
      visit new_user_session_path

      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password

      find('input[type="submit"]').click

      expect(page).to have_current_path(posts_path)
    end
  end

  describe 'Deviseヘルパーを使った認証' do
    let(:user) { create(:user) }

    it 'Deviseヘルパーでログインできる' do
      sign_in user
      visit posts_path
      expect(page).to have_current_path(posts_path)

      visit new_post_path
      expect(page).to have_current_path(new_post_path)
    end
  end
end
