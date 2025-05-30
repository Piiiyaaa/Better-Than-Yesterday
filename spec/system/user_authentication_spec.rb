require 'rails_helper'

RSpec.describe 'Userテスト', type: :system do
  describe 'ユーザー登録フォーム' do
    it 'ユーザー登録ができる' do
      visit new_user_registration_path

      # 10文字以内の短いユーザー名を使用
      timestamp = Time.current.to_i.to_s[-6..-1] # 6桁の数字
      unique_email = "test#{timestamp}@example.com"
      unique_username = "user#{timestamp}" # 10文字以内

      puts "=== Registration Details ==="
      puts "Username: #{unique_username} (#{unique_username.length} chars)"
      puts "Email: #{unique_email}"
      puts "Current URL before: #{page.current_url}"

      fill_in 'user[username]', with: unique_username
      fill_in 'user[email]', with: unique_email
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'

      sleep 0.5 if ENV['CI'] == 'true'

      puts "=== About to submit ==="
      find('input[type="submit"]').click

      puts "=== After submission ==="
      puts "Current URL: #{page.current_url}"

      # ページ内容の詳細確認
      if page.current_path == '/users/sign_up'
        puts "=== Still on signup page - checking for errors ==="

        # Deviseのエラーメッセージ
        if page.has_selector?('#error_explanation')
          puts "Devise errors found:"
          puts page.find('#error_explanation').text
        end

        # フィールドエラー
        page.all('.field_with_errors').each do |error|
          puts "Field error: #{error.text}"
        end

        # 隠れたエラーメッセージ
        page.all('[class*="error"], [class*="invalid"]').each do |error|
          puts "General error: #{error.text}" unless error.text.strip.empty?
        end

        # ページ全体のテキストの一部を表示
        puts "=== Page content preview ==="
        puts page.text[0..300]
      end

      # データベース確認
      user_exists = User.find_by(email: unique_email)
      puts "=== Database check ==="
      puts "User created: #{user_exists.present?}"
      if user_exists
        puts "User valid: #{user_exists.valid?}"
        puts "User errors: #{user_exists.errors.full_messages}" unless user_exists.valid?
      end

      # 成功を確認
      expect(page).to have_current_path(posts_path, wait: 15)
    end
  end
end
