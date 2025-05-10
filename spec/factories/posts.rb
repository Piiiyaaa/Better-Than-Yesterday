FactoryBot.define do
    factory :post do
        title { "テスト投稿タイトル" }
        body { "これはテスト投稿の本文です。学習内容を記録するためのサンプルテキストです。" }
        learning_date { Date.current }
        association :user
    end

    trait :with_image do
        after(:build) do |post|
            file = StringIO.new("dummy image content")
            post.image.attach(
              io: file,
              filename: 'test_image.jpg',
              content_type: 'image/jpeg'
            )
        end
    end
  end
