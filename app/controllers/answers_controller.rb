class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_daily_question, only: [:create]
    before_action :check_already_answered, only: [:create]
  
    def create
      @answer = @daily_question.answers.build(answer_params)
      @answer.user = current_user
      
      # 正解判定
      correct_answer = @daily_question.question_answer.strip.downcase
      user_answer = @answer.answer_text.strip.downcase
      @answer.is_correct = (correct_answer == user_answer)
      
      if @answer.save
        # AnswerRecordを更新
        update_answer_record(@answer)
        
        redirect_to daily_question_path(@daily_question), 
                    notice: @answer.is_correct ? "正解です！🎉" : "不正解でした。解答を確認してみてください。"
      else
        flash.now[:alert] = "回答の保存に失敗しました。"
        render 'daily_questions/show'
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
      params.require(:answer).permit(:answer_text)
    end
  
    def update_answer_record(answer)
      record = current_user.answer_record
      record.increment_challenge!(answer.is_correct)
    end
  end
  