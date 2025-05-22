class AddQuestionTypeToDailyQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_questions, :question_type, :integer
  end
end
