class CreateAnswerRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :answer_records do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_challenge
      t.integer :total_correct
      t.float :correct_rate

      t.timestamps
    end
  end
end
