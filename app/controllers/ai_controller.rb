require "openai"

class AiController < ApplicationController
  protect_from_forgery with: :null_session, only: [ :generate_question ]

  def generate_question
    # 学習内容を取得
    learning_content = params[:learning_content]

    if learning_content.blank?
      return render json: { error: "学習内容がありません" }, status: :bad_request
    end

    Rails.logger.info "AI問題生成リクエスト: 学習内容「#{learning_content&.truncate(50)}」"

    begin
      # OpenAI APIを使用して問題を生成
      question_data = generate_question_with_openai(learning_content)

      render json: question_data
    rescue => e
      Rails.logger.error "AI問題生成エラー: #{e.message}"

      # エラーが発生した場合はモックデータを返す（フォールバック）
      render json: {
        body: "次のうち、正しいのはどれ？\nA) 財産権は、公共の福祉に適合するように、法律でこれを定める\nB) 財産権は、無制限に保障される\nC) 財産権は、政府によって自由に制限できる",
        question_answer: "A"
      }
    end
  end

  private

  def generate_question_with_openai(learning_content)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    prompt = <<~PROMPT
      あなたは教育の専門家です。以下の学習内容を基に、学習者の理解度を確認するための問題を1つ作成してください。選択式か穴埋め式のどちらかで作成してください。

      学習内容:
      #{learning_content}

      以下の形式で問題と選択肢を作成してください:
      次のうち、正しいのはどれ？
      A) [選択肢1]
      B) [選択肢2]
      C) [選択肢3]

      また、正解の選択肢（AまたはBまたはC）も明確に教えてください。
      応答は問題文と正解を分けて、わかりやすく提示してください。
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # 高速で安価
        messages: [
          {
            role: "system",
            content: "あなたは教育専門家です。学習内容から選択式問題を作成するアシスタントです。問題は日本語で作成してください。"
          },
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 500
      }
    )

    # レスポンスから問題と正解を抽出
    ai_response = response.dig("choices", 0, "message", "content")
    Rails.logger.info "AI応答: #{ai_response}"

    # 問題と正解を分離
    question, answer = parse_ai_response(ai_response)

    {
      body: question,
      question_answer: answer
    }
  end

  def parse_ai_response(response)
    # 正解を抽出（複数のパターンに対応）
    answer_patterns = [
      /正解[はは：:\s]*([ABC])/i,
      /答え[はは：:\s]*([ABC])/i,
      /正答[はは：:\s]*([ABC])/i,
      /([ABC])[）)]\s*が正[しい解]/i,
      /選択肢\s*([ABC])/i
    ]

    answer = "A" # デフォルト値

    answer_patterns.each do |pattern|
      match = response.match(pattern)
      if match
        answer = match[1].upcase
        break
      end
    end

    # 正解の説明部分を削除して問題部分だけを残す
    question = response.dup

    # 正解に関する説明を削除
    question = question.gsub(/正解[はは：:\s]*[ABC].*$/im, "").strip
    question = question.gsub(/答え[はは：:\s]*[ABC].*$/im, "").strip
    question = question.gsub(/正答[はは：:\s]*[ABC].*$/im, "").strip
    question = question.gsub(/[ABC][）)]\s*が正[しい解].*$/im, "").strip

    # 問題の書式をきれいにする
    unless question.include?("次のうち、正しいのはどれ？")
      question = question.gsub(/^問題[：:]\s*/i, "")
      question = "次のうち、正しいのはどれ？\n" + question unless question.start_with?("次のうち")
    end

    # 余分な改行を整理
    question = question.gsub(/\n{3,}/, "\n\n").strip

    [ question, answer ]
  end
end
