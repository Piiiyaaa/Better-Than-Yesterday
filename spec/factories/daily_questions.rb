FactoryBot.define do
    factory :daily_question do
      body { "これは日々の問題です。" }
      question_answer { "これが答えです。" }
      question_type { :description }
      association :post
    end
end
