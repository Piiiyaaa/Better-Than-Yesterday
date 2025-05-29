FactoryBot.define do
    factory :post do
      title { "テスト投稿" }
      body { "これはテスト用の投稿です。" }
      learning_date { Date.current }
      association :user

      after(:create) do |post|
        create(:daily_question, post: post) unless post.daily_question
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
  end
