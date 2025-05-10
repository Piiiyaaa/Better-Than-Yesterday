FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { 'password123' }
      password_confirmation { 'password123' }
      sequence(:username) { |n| "テストユーザー#{n}" }
      bio { 'これは自己紹介文です。RSpecのテスト用に作成しました。' }
    end
  end
