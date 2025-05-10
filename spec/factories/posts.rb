FactoryBot.define do
    factory :post do
        title { "テスト投稿タイトル" }
        body { "これはテスト投稿の本文です。学習内容を記録するためのサンプルテキストです。" }
        learning_date { Date.current }
        association :user
    end

    trait :with_image_post do
        after(:build) do |post|
        post.images.attach(
            io: File.open(Rails.root.join('app/assets/images/arror.png')),
            filename: 'arror.png',
            content_type: 'image/png'
        )
        end
    end
end
