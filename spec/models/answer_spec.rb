require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:daily_question) { create(:daily_question) }

    it '有効な回答を作成できる' do
      answer = build(:answer, user: user, daily_question: daily_question, is_correct: true)
      expect(answer).to be_valid
    end

    it '同じユーザーが同じ問題に重複回答できないことをバリデーションでチェックする' do
      create(:answer, user: user, daily_question: daily_question, is_correct: true)
      duplicate_answer = build(:answer, user: user, daily_question: daily_question, is_correct: false)
      expect(duplicate_answer).to be_invalid
      expect(duplicate_answer.errors[:user_id]).not_to be_empty
    end

    it 'is_correctがtrue/false以外の場合にバリデーションが機能してinvalidになるか' do
      answer_without_is_correct = build(:answer, user: user, daily_question: daily_question)
      answer_without_is_correct.is_correct = nil
      expect(answer_without_is_correct).to be_invalid
      expect(answer_without_is_correct.errors[:is_correct]).not_to be_empty
    end
  end

  describe 'スコープ' do
    let(:user) { create(:user) }
    let(:daily_question) { create(:daily_question) }

    before do
      create(:answer, user: user, daily_question: daily_question, is_correct: true)
      create(:answer, user: create(:user), daily_question: daily_question, is_correct: false)
    end

    it 'correctスコープで正解のみ取得できる' do
      expect(Answer.correct.count).to eq(1)
      expect(Answer.correct.first.is_correct).to be_truthy
    end

    it 'incorrectスコープで不正解のみ取得できる' do
      expect(Answer.incorrect.count).to eq(1)
      expect(Answer.incorrect.first.is_correct).to be_falsy
    end
  end

  describe '.daily_stats_for_user' do
    let(:user) { create(:user) }

    it 'ユーザーの日別統計を取得できる' do
      daily_question = create(:daily_question)
      create(:answer, user: user, daily_question: daily_question, is_correct: true, created_at: Date.current)
      
      stats = Answer.daily_stats_for_user(user, 1)
      expect(stats).to be_an(Array)
      expect(stats.first[:correct_count]).to eq(1)
      expect(stats.first[:total_count]).to eq(1)
      expect(stats.first[:correct_rate]).to eq(100.0)
    end
  end
end