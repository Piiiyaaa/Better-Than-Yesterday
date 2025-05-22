FactoryBot.define do
  factory :answer_record do
    user { nil }
    total_challenge { 1 }
    total_correct { 1 }
    correct_rate { 1.5 }
  end
end
