FactoryBot.define do
  factory :answer do
    user { nil }
    daily_question { nil }
    answer_text { "MyText" }
    is_correct { false }
  end
end
