class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :daily_question, null: false, foreign_key: true
      t.text :answer_text
      t.boolean :is_correct

      t.timestamps
    end
  end
end
