class AiController < ApplicationController
  protect_from_forgery with: :null_session, only: [ :generate_question ]

  def generate_question
    # ログに記録（デバッグ用）
    Rails.logger.info "AI問題生成リクエスト: #{params.inspect}"

    # 実際のAPIの代わりにモックデータを返す
    render json: {
      body: "次のうち、正しいのはどれ？\nA) 財産権は、公共の福祉に適合するように、法律でこれを定める\nB) 財産権は、無制限に保障される\nC) 財産権は、政府によって自由に制限できる",
      question_answer: "A"
    }
  end
end
