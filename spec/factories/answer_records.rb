FactoryBot.define do
  factory :answer_record do
    total_challenge { 10 }
    total_correct { 7 }
    correct_rate { 70.0 }
    association :user
  end
end