class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_question, only: [ :create ]
  before_action :check_already_answered, only: [ :create ]

  def create
    @answer = @daily_question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      # AnswerRecordを更新
      update_answer_record(@answer)

      result_message = @answer.is_correct ? "正解として記録しました！🎉" : "不正解として記録しました。また挑戦してみてください！"
      redirect_to daily_question_path(@daily_question), notice: result_message
    else
      flash.now[:alert] = "記録の保存に失敗しました。"
      render "daily_questions/show"
    end
  end

  private

  def set_daily_question
    @daily_question = DailyQuestion.find(params[:daily_question_id])
  end

  def check_already_answered
    if current_user.answered_question?(@daily_question)
      redirect_to daily_question_path(@daily_question),
                  alert: "この問題にはすでに回答済みです。"
    end
  end

  def answer_params
    params.require(:answer).permit(:is_correct)
  end

  def update_answer_record(answer)
    record = current_user.answer_record
    record.increment_challenge!(answer.is_correct)
  end
end
