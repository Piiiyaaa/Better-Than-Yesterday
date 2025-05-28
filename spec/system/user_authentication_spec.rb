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
      
      fill_in 'user[username]', with: 'testuser'
      fill_in 'user[email]', with: 'test@example.com'
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'
      find('input[type="submit"]').click
      
      expect(page).to have_current_path(posts_path)
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