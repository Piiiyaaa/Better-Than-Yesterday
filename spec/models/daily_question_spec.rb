require 'rails_helper'

RSpec.describe DailyQuestion, type: :model do
  describe 'バリデーション' do
    let(:post) { create(:post) }

    it '有効な問題を作成できる' do
      question = build(:daily_question, post: post)
      expect(question).to be_valid
    end

    it '問題文がないときにバリデーションが機能してinvalidになるか' do
      question_without_body = build(:daily_question, post: post, body: "")
      expect(question_without_body).to be_invalid
      expect(question_without_body.errors[:body]).not_to be_empty
    end

    it '問題文が400文字を超える場合にバリデーションが機能してinvalidになるか' do
      question_with_long_body = build(:daily_question, post: post, body: 'a' * 401)
      expect(question_with_long_body).to be_invalid
      expect(question_with_long_body.errors[:body]).not_to be_empty
    end

    it '答えがないときにバリデーションが機能してinvalidになるか' do
      question_without_answer = build(:daily_question, post: post, question_answer: "")
      expect(question_without_answer).to be_invalid
      expect(question_without_answer.errors[:question_answer]).not_to be_empty
    end
  end

  describe 'メソッド' do
    let(:daily_question) { create(:daily_question) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      create(:answer, daily_question: daily_question, user: user1, is_correct: true)
      create(:answer, daily_question: daily_question, user: user2, is_correct: false)
    end

    it 'correct_rateで正答率を計算できる' do
      expect(daily_question.correct_rate).to eq(50.0)
    end

    it 'answer_countで回答数を取得できる' do
      expect(daily_question.answer_count).to eq(2)
    end

    it 'user_answerで特定ユーザーの回答を取得できる' do
      answer = daily_question.user_answer(user1)
      expect(answer.user).to eq(user1)
      expect(answer.is_correct).to be_truthy
    end
  end

  describe 'enum' do
    it 'question_typeが正しく設定される' do
      question = create(:daily_question, question_type: :multiple_choice)
      expect(question.multiple_choice?).to be_truthy
      expect(question.question_type_name).to eq('選択式')
    end
  end
end
