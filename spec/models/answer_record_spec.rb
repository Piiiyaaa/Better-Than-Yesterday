require 'rails_helper'

RSpec.describe AnswerRecord, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }

    it '有効なレコードを作成できる' do
      # Userの作成時に自動生成されるAnswer_recordを使用
      record = user.answer_record
      expect(record).to be_valid
    end

    it 'total_challengeが負数の場合にバリデーションが機能してinvalidになるか' do
      record = user.answer_record
      record.total_challenge = -1
      expect(record).to be_invalid
      expect(record.errors[:total_challenge]).not_to be_empty
    end

    it 'total_correctが負数の場合にバリデーションが機能してinvalidになるか' do
      record = user.answer_record
      record.total_correct = -1
      expect(record).to be_invalid
      expect(record.errors[:total_correct]).not_to be_empty
    end

    it 'correct_rateが0-100の範囲外の場合にバリデーションが機能してinvalidになるか' do
      record = user.answer_record
      record.correct_rate = 101
      expect(record).to be_invalid
      expect(record.errors[:correct_rate]).not_to be_empty
    end

    it 'ユーザーごとに一意であることをバリデーションでチェックする' do
      # 既にuser作成時にanswer_recordが作成されているので、新しく作ろうとするとエラー
      duplicate_record = build(:answer_record, user: user)
      expect(duplicate_record).to be_invalid
      expect(duplicate_record.errors[:user_id]).not_to be_empty
    end
  end

  describe 'メソッド' do
    let(:user) { create(:user) }
    let(:record) do
      # 既存のanswer_recordを更新
      answer_record = user.answer_record
      answer_record.update!(total_challenge: 5, total_correct: 3, correct_rate: 60.0)
      answer_record
    end

    it 'update_correct_rate!で正解率を更新できる' do
      record.update_correct_rate!
      expect(record.correct_rate).to eq(60.0)
    end

    it 'increment_challenge!でチャレンジ数と正解数を更新できる' do
      record.increment_challenge!(true)
      expect(record.total_challenge).to eq(6)
      expect(record.total_correct).to eq(4)
      expect(record.correct_rate).to eq(66.67)
    end
  end
end