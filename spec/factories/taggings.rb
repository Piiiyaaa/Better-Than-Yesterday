FactoryBot.define do
  factory :tagging do
    association :tag
    association :post
  end
end
