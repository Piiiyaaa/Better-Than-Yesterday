class AddUniqueIndexToAnswers < ActiveRecord::Migration[7.2]
  def change
    add_index :answers, [ :user_id, :daily_question_id ], unique: true, name: 'index_answers_on_user_and_question'
  end
end
