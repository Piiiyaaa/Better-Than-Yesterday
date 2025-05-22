class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :daily_question
end
